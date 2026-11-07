/*
 * patch-shebangs: Rewrite script interpreter paths to Nix store paths
 * C99/POSIX implementation for maximum portability
 */

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <utime.h>

#define MAX_SHEBANG 512
#define MAX_PATH 4096

static const char *g_path_var;
static const char *g_nix_store;
static int g_update;

static char *which(const char *cmd, const char *path)
{
    char *dir, *pathdup, *result;
    static char buf[MAX_PATH];
    if (!cmd || !*cmd || !path) return NULL;
    pathdup = strdup(path);
    if (!pathdup) return NULL;
    for (dir = strtok(pathdup, ":"); dir; dir = strtok(NULL, ":")) {
        sprintf(buf, "%s/%s", dir, cmd);
        if (access(buf, X_OK) == 0) {
            result = strdup(buf);
            free(pathdup);
            return result;
        }
    }
    free(pathdup);
    return NULL;
}

static const char *mybasename(const char *path)
{
    const char *p = strrchr(path, '/');
    return p ? p + 1 : path;
}

static int endswith(const char *s, const char *suffix)
{
    size_t slen = strlen(s), sufflen = strlen(suffix);
    return slen >= sufflen && strcmp(s + slen - sufflen, suffix) == 0;
}

static int patch_file(const char *filepath)
{
    FILE *f;
    char shebang[MAX_SHEBANG], *content, *newline;
    char old_path[MAX_PATH], arg0[MAX_PATH], args[MAX_SHEBANG];
    char new_shebang[MAX_SHEBANG], *new_path, *space;
    char *rest, *tmppath;
    struct stat st;
    struct utimbuf times;
    int was_readonly;
    size_t len;

    f = fopen(filepath, "rb");
    if (!f) return 0;
    if (!fgets(shebang, sizeof(shebang), f)) { fclose(f); return 0; }
    fclose(f);

    if (shebang[0] != '#' || shebang[1] != '!') return 0;
    newline = strchr(shebang, '\n');
    if (newline) *newline = '\0';

    content = shebang + 2;
    while (*content == ' ' || *content == '\t') content++;

    old_path[0] = arg0[0] = args[0] = '\0';
    if (!*content) {
        strcpy(old_path, "/bin/sh");
    } else if ((space = strchr(content, ' '))) {
        len = space - content;
        if (len >= sizeof(old_path)) len = sizeof(old_path) - 1;
        strncpy(old_path, content, len);
        old_path[len] = '\0';
        rest = space + 1;
        while (*rest == ' ') rest++;
        if ((space = strchr(rest, ' '))) {
            len = space - rest;
            if (len >= sizeof(arg0)) len = sizeof(arg0) - 1;
            strncpy(arg0, rest, len);
            arg0[len] = '\0';
            rest = space + 1;
            while (*rest == ' ') rest++;
            strncpy(args, rest, sizeof(args) - 1);
        } else {
            strncpy(arg0, rest, sizeof(arg0) - 1);
        }
    } else {
        strncpy(old_path, content, sizeof(old_path) - 1);
    }

    if (!old_path[0]) strcpy(old_path, "/bin/sh");
    new_path = NULL;

    if (endswith(old_path, "/bin/env")) {
        if (strcmp(arg0, "-S") == 0) {
            /* -S: arg0 becomes the real command from args, args becomes rest */
            char real_cmd[MAX_PATH], rest_args[MAX_SHEBANG], *env_path, *cmd_path;
            real_cmd[0] = rest_args[0] = '\0';
            if (args[0] && (space = strchr(args, ' '))) {
                len = space - args;
                if (len >= sizeof(real_cmd)) len = sizeof(real_cmd) - 1;
                strncpy(real_cmd, args, len);
                real_cmd[len] = '\0';
                rest = space + 1;
                while (*rest == ' ') rest++;
                strncpy(rest_args, rest, sizeof(rest_args) - 1);
            } else if (args[0]) {
                strncpy(real_cmd, args, sizeof(real_cmd) - 1);
            }
            env_path = which("env", g_path_var);
            cmd_path = real_cmd[0] ? which(real_cmd, g_path_var) : NULL;
            if (env_path && cmd_path) {
                new_path = env_path;
                if (rest_args[0])
                    sprintf(args, "-S %s %s", cmd_path, rest_args);
                else
                    sprintf(args, "-S %s", cmd_path);
            } else return 0;
        } else if (arg0[0] == '-' || strchr(arg0, '=')) {
            fprintf(stderr, "%s: unsupported interpreter directive \"%s\" "
                "(set dontPatchShebangs=1 and handle shebang patching yourself)\n",
                filepath, shebang);
            exit(1);
        } else {
            new_path = arg0[0] ? which(arg0, g_path_var) : NULL;
        }
    } else {
        new_path = which(mybasename(old_path), g_path_var);
        if (arg0[0]) {
            if (args[0]) { char t[MAX_SHEBANG]; sprintf(t, "%s %s", arg0, args); strcpy(args, t); }
            else strcpy(args, arg0);
        }
    }

    if (!new_path) return 0;
    if (!g_update && g_nix_store && strncmp(old_path, g_nix_store, strlen(g_nix_store)) == 0) return 0;
    if (strcmp(new_path, old_path) == 0) return 0;

    if (args[0]) {
        char *e = args + strlen(args) - 1;
        while (e > args && *e == ' ') *e-- = '\0';
        sprintf(new_shebang, "#!%s %s", new_path, args);
    } else {
        sprintf(new_shebang, "#!%s", new_path);
    }

    if (stat(filepath, &st) != 0) return 0;
    was_readonly = !(st.st_mode & S_IWUSR);
    if (was_readonly && chmod(filepath, st.st_mode | S_IWUSR) != 0) return 0;

    tmppath = malloc(strlen(filepath) + 5);
    sprintf(tmppath, "%s.tmp", filepath);

    f = fopen(filepath, "rb");
    if (f) {
        FILE *out = fopen(tmppath, "wb");
        if (out) {
            char buf[4096];
            size_t n;
            int c;
            /* Write new shebang */
            fprintf(out, "%s\n", new_shebang);
            /* Skip old first line */
            while ((c = fgetc(f)) != EOF && c != '\n') ;
            /* Copy rest of file (binary-safe) */
            while ((n = fread(buf, 1, sizeof(buf), f)) > 0)
                fwrite(buf, 1, n, out);
            fclose(out);
            fclose(f);
            rename(tmppath, filepath);
        } else fclose(f);
    }
    free(tmppath);

    times.actime = st.st_atime;
    times.modtime = st.st_mtime;
    utime(filepath, &times);
    if (was_readonly) chmod(filepath, st.st_mode);

    printf("%s: interpreter directive changed from \"%s\" to \"%s\"\n", filepath, shebang, new_shebang);
    return 1;
}

static void process_dir(const char *path)
{
    DIR *d;
    struct dirent *e;
    struct stat st;
    char fullpath[MAX_PATH];

    d = opendir(path);
    if (!d) return;
    while ((e = readdir(d))) {
        if (e->d_name[0] == '.' && (!e->d_name[1] || (e->d_name[1] == '.' && !e->d_name[2])))
            continue;
        sprintf(fullpath, "%s/%s", path, e->d_name);
        if (stat(fullpath, &st) != 0) continue;
        if (S_ISDIR(st.st_mode)) {
            process_dir(fullpath);
        } else if (S_ISREG(st.st_mode) && (st.st_mode & S_IXUSR)) {
            patch_file(fullpath);
        }
    }
    closedir(d);
}

int main(int argc, char *argv[])
{
    int i, use_host = -1;
    struct stat st;

    for (i = 1; i < argc && argv[i][0] == '-'; i++) {
        if (strcmp(argv[i], "--host") == 0) use_host = 1;
        else if (strcmp(argv[i], "--build") == 0) use_host = 0;
        else if (strcmp(argv[i], "--update") == 0) g_update = 1;
        else if (strcmp(argv[i], "--") == 0) { i++; break; }
        else { fprintf(stderr, "Unknown option %s\n", argv[i]); return 1; }
    }

    if (i >= argc) { fprintf(stderr, "No paths supplied to patchShebangs\n"); return 0; }

    g_nix_store = getenv("NIX_STORE");
    if (!g_nix_store) g_nix_store = "/nix/store";
    g_path_var = getenv(use_host == 1 ? "HOST_PATH" : "PATH");
    if (!g_path_var) g_path_var = "";

    printf("patching script interpreter paths in");
    { int j; for (j = i; j < argc; j++) printf(" %s", argv[j]); }
    printf("\n");

    for (; i < argc; i++) {
        if (stat(argv[i], &st) != 0) continue;
        if (S_ISDIR(st.st_mode)) process_dir(argv[i]);
        else if (S_ISREG(st.st_mode) && (st.st_mode & S_IXUSR)) patch_file(argv[i]);
    }
    return 0;
}
