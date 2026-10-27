#define _GNU_SOURCE
#include <dlfcn.h>
#include <string.h>
#include <unistd.h>

/*
 * LycheeSlicer reads /proc/self/exe in registerProtocolHandler() to generate
 * ~/.local/share/applications/lycheeslicer-url-handler.desktop for OAuth login.
 * Inside the FHS environment, /proc/self/exe resolves to the raw un-wrapped
 * store path (/nix/store/...-extracted/opt/Lychee/LycheeSlicer), which cannot
 * run outside the FHS container.
 * Intercepting readlink("/proc/self/exe") to return "lycheeslicer" ensures
 * the generated desktop file uses "Exec=lycheeslicer %u", which properly
 * executes via the FHS wrapper on the host.
 */
ssize_t readlink(const char *pathname, char *buf, size_t bufsiz) {
    if (pathname && strcmp(pathname, "/proc/self/exe") == 0) {
        const char *target = "lycheeslicer";
        size_t len = strlen(target);
        if (bufsiz < len) len = bufsiz;
        memcpy(buf, target, len);
        return len;
    }
    ssize_t (*orig_readlink)(const char *, char *, size_t) = dlsym(RTLD_NEXT, "readlink");
    return orig_readlink(pathname, buf, bufsiz);
}

ssize_t readlinkat(int dirfd, const char *pathname, char *buf, size_t bufsiz) {
    if (pathname && strcmp(pathname, "/proc/self/exe") == 0) {
        const char *target = "lycheeslicer";
        size_t len = strlen(target);
        if (bufsiz < len) len = bufsiz;
        memcpy(buf, target, len);
        return len;
    }
    ssize_t (*orig_readlinkat)(int, const char *, char *, size_t) = dlsym(RTLD_NEXT, "readlinkat");
    return orig_readlinkat(dirfd, pathname, buf, bufsiz);
}
