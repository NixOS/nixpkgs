#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <assert.h>
#include <errno.h>
#include <linux/capability.h>
#include <sys/capability.h>
#include <sys/prctl.h>
#include <limits.h>
#include <cap-ng.h>

// Make sure assertions are not compiled out, we use them to codify
// invariants about this program and we want it to fail fast and
// loudly if they are violated.
#undef NDEBUG

extern char **environ;

// The WRAPPER_DIR macro is supplied at compile time so that it cannot
// be changed at runtime
static char * wrapperDir = WRAPPER_DIR;

// Wrapper debug variable name
static char * wrapperDebug = "WRAPPER_DEBUG";

// Update the capabilities of the running process to include the given
// capability in the Ambient set.
static void set_ambient_cap(cap_value_t cap)
{
    capng_get_caps_process();

    if (capng_update(CAPNG_ADD, CAPNG_INHERITABLE, (unsigned long) cap))
    {
        perror("cannot raise the capability into the Inheritable set\n");
        exit(1);
    }

    capng_apply(CAPNG_SELECT_CAPS);
    
    if (prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, (unsigned long) cap, 0, 0))
    {
        perror("cannot raise the capability into the Ambient set\n");
        exit(1);
    }
}

// Given the path to this program, fetch its configured capability set
// (as set by `setcap ... /path/to/file`) and raise those capabilities
// into the Ambient set.
static int make_caps_ambient(const char *selfPath)
{
    cap_t caps = cap_get_file(selfPath);

    if(!caps)
    {
        if(getenv(wrapperDebug))
            fprintf(stderr, "no caps set or could not retrieve the caps for this file, not doing anything...");

        return 1;
    }

    // We use `cap_to_text` and iteration over the tokenized result
    // string because, as of libcap's current release, there is no
    // facility for retrieving an array of `cap_value_t`'s that can be
    // given to `prctl` in order to lift that capability into the
    // Ambient set.
    //
    // Some discussion was had around shot-gunning all of the
    // capabilities we know about into the Ambient set but that has a
    // security smell and I deemed the risk of the current
    // implementation crashing the program to be lower than the risk
    // of a privilege escalation security hole being introduced by
    // raising all capabilities, even ones we didn't intend for the
    // program, into the Ambient set.
    //
    // `cap_t` which is returned by `cap_get_*` is an opaque type and
    // even if we could retrieve the bitmasks (which, as far as I can
    // tell we cannot) in order to get the `cap_value_t`
    // representation for each capability we would have to take the
    // total number of capabilities supported and iterate over the
    // sequence of integers up-to that maximum total, testing each one
    // against the bitmask ((bitmask >> n) & 1) to see if it's set and
    // aggregating each "capability integer n" that is set in the
    // bitmask.
    //
    // That, combined with the fact that we can't easily get the
    // bitmask anyway seemed much more brittle than fetching the
    // `cap_t`, transforming it into a textual representation,
    // tokenizing the string, and using `cap_from_name` on the token
    // to get the `cap_value_t` that we need for `prctl`. There is
    // indeed risk involved if the output string format of
    // `cap_to_text` ever changes but at this time the combination of
    // factors involving the below list have led me to the conclusion
    // that the best implementation at this time is reading then
    // parsing with *lots of documentation* about why we're doing it
    // this way.
    //
    // 1. No explicit API for fetching an array of `cap_value_t`'s or
    //    for transforming a `cap_t` into such a representation
    // 2. The risk of a crash is lower than lifting all capabilities
    //    into the Ambient set
    // 3. libcap is depended on heavily in the Linux ecosystem so
    //    there is a high chance that the output representation of
    //    `cap_to_text` will not change which reduces our risk that
    //    this parsing step will cause a crash
    //
    // The preferred method, should it ever be available in the
    // future, would be to use libcap API's to transform the result
    // from a `cap_get_*` into an array of `cap_value_t`'s that can
    // then be given to prctl.
    //
    // - Parnell
    ssize_t capLen;
    char* capstr = cap_to_text(caps, &capLen);
    cap_free(caps);
    
    // TODO: For now, we assume that cap_to_text always starts its
    // result string with " =" and that the first capability is listed
    // immediately after that. We should verify this.
    assert(capLen >= 2);
    capstr += 2;

    char* saveptr = NULL;
    for(char* tok = strtok_r(capstr, ",", &saveptr); tok; tok = strtok_r(NULL, ",", &saveptr))
    {
      cap_value_t capnum;
      if (cap_from_name(tok, &capnum))
      {
          if(getenv(wrapperDebug))
              fprintf(stderr, "cap_from_name failed, skipping: %s", tok);
      }
      else if (capnum == CAP_SETPCAP)
      {
          // Check for the cap_setpcap capability, we set this on the
          // wrapper so it can elevate the capabilities to the Ambient
          // set but we do not want to propagate it down into the
          // wrapped program.
          //
          // TODO: what happens if that's the behavior you want
          // though???? I'm preferring a strict vs. loose policy here.
          if(getenv(wrapperDebug))
              fprintf(stderr, "cap_setpcap in set, skipping it\n");
      }
      else
      {
          set_ambient_cap(capnum);

          if(getenv(wrapperDebug))
              fprintf(stderr, "raised %s into the Ambient capability set\n", tok);
      }
    }
    cap_free(capstr);

    return 0;
}

int main(int argc, char * * argv)
{
    // I *think* it's safe to assume that a path from a symbolic link
    // should safely fit within the PATH_MAX system limit. Though I'm
    // not positive it's safe...
    char selfPath[PATH_MAX];
    int selfPathSize = readlink("/proc/self/exe", selfPath, sizeof(selfPath));

    assert(selfPathSize > 0);

    // Assert we have room for the zero byte, this ensures the path
    // isn't being truncated because it's too big for the buffer.
    //
    // A better way to handle this might be to use something like the
    // whereami library (https://github.com/gpakosz/whereami) or a
    // loop that resizes the buffer and re-reads the link if the
    // contents are being truncated.
    assert(selfPathSize < sizeof(selfPath));

    // Set the zero byte since readlink doesn't do that for us.
    selfPath[selfPathSize] = '\0';

    // Make sure that we are being executed from the right location,
    // i.e., `safeWrapperDir'.  This is to prevent someone from creating
    // hard link `X' from some other location, along with a false
    // `X.real' file, to allow arbitrary programs from being executed
    // with elevated capabilities.
    int len = strlen(wrapperDir);
    if (len > 0 && '/' == wrapperDir[len - 1])
      --len;
    assert(!strncmp(selfPath, wrapperDir, len));
    assert('/' == wrapperDir[0]);
    assert('/' == selfPath[len]);

    // Make *really* *really* sure that we were executed as
    // `selfPath', and not, say, as some other setuid program. That
    // is, our effective uid/gid should match the uid/gid of
    // `selfPath'.
    struct stat st;
    assert(lstat(selfPath, &st) != -1);

    assert(!(st.st_mode & S_ISUID) || (st.st_uid == geteuid()));
    assert(!(st.st_mode & S_ISGID) || (st.st_gid == getegid()));

    // And, of course, we shouldn't be writable.
    assert(!(st.st_mode & (S_IWGRP | S_IWOTH)));

    // Read the path of the real (wrapped) program from <self>.real.
    char realFN[PATH_MAX + 10];
    int realFNSize = snprintf (realFN, sizeof(realFN), "%s.real", selfPath);
    assert (realFNSize < sizeof(realFN));

    int fdSelf = open(realFN, O_RDONLY);
    assert (fdSelf != -1);

    char sourceProg[PATH_MAX];
    len = read(fdSelf, sourceProg, PATH_MAX);
    assert (len != -1);
    assert (len < sizeof(sourceProg));
    assert (len > 0);
    sourceProg[len] = 0;

    close(fdSelf);

    // Read the capabilities set on the wrapper and raise them in to
    // the Ambient set so the program we're wrapping receives the
    // capabilities too!
    make_caps_ambient(selfPath);

    execve(sourceProg, argv, environ);
    
    fprintf(stderr, "%s: cannot run `%s': %s\n",
        argv[0], sourceProg, strerror(errno));

    exit(1);
}


