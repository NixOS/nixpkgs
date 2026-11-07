/*
 * wemeet-x11-fix.c
 *
 * This library intercepts X11 functions that cause crashes in Wayland mode.
 * Specifically, it prevents XSetInputFocus from crashing when called in
 * pure Wayland environment.
 *
 * Compile: gcc -shared -fPIC -o libwemeet-x11-fix.so wemeet-x11-fix.c -ldl
 * Usage: LD_PRELOAD=./libwemeet-x11-fix.so wemeet
 */

#define _GNU_SOURCE
#include <dlfcn.h>
#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Original XSetInputFocus function pointer
static int (*orig_XSetInputFocus)(Display*, Window, int, Time) = NULL;

// Hooked XSetInputFocus that safely handles Wayland environment
int XSetInputFocus(Display *display, Window focus, int revert_to, Time time) {
    // Check if we're in a Wayland session
    const char *session_type = getenv("XDG_SESSION_TYPE");
    const char *wayland_display = getenv("WAYLAND_DISPLAY");

    if ((session_type && strcmp(session_type, "wayland") == 0) || wayland_display) {
        // In pure Wayland, XSetInputFocus can crash due to invalid X11 display
        // Just return success and skip the actual call
        fprintf(stderr, "wemeet-x11-fix: Blocking XSetInputFocus in Wayland mode\n");
        return Success;
    }

    // Load original function if not already loaded
    if (!orig_XSetInputFocus) {
        orig_XSetInputFocus = dlsym(RTLD_NEXT, "XSetInputFocus");
        if (!orig_XSetInputFocus) {
            fprintf(stderr, "wemeet-x11-fix: Failed to load XSetInputFocus\n");
            return BadWindow;
        }
    }

    // Call original function in X11 mode
    return orig_XSetInputFocus(display, focus, revert_to, time);
}

// Also intercept _XGetRequest to add error handling
static Status (*orig_XGetRequest)(Display*,  _Xconst char*, size_t, int) = NULL;

__attribute__((constructor))
static void init_x11_fix(void) {
    fprintf(stderr, "wemeet-x11-fix: Loaded X11 compatibility fix for Wayland\n");
}
