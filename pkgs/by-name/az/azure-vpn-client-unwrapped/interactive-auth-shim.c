#define _GNU_SOURCE
#include <dlfcn.h>
#include <systemd/sd-bus.h>

static int (*real_sd_bus_open_system_with_description)(sd_bus **, const char *) = NULL;

int sd_bus_open_system_with_description(sd_bus **ret, const char *description) {
    if (!real_sd_bus_open_system_with_description) {
        real_sd_bus_open_system_with_description = dlsym(
            RTLD_NEXT,
            "sd_bus_open_system_with_description"
        );
    }

    int r = real_sd_bus_open_system_with_description(ret, description);

    if (r >= 0 && ret && *ret) {
        sd_bus_set_allow_interactive_authorization(*ret, 1);
    }

    return r;
}

