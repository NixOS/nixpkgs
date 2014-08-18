/* This is a small helper to recursively expand GCC response files and return
 * them as a BASH array called $params.
 *
 * See https://gcc.gnu.org/wiki/Response_Files for more information about it.
 */

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include <libiberty.h>

int main(int argc, char **argv)
{
    int i, j;
    const char *arg;
    size_t arglen;

    expandargv(&argc, &argv);

    fputs("params=(", stdout);

    for (i = 1; i < argc; ++i) {
        arg = argv[i];
        arglen = strlen(argv[i]);

        fputs(" '", stdout);
        for (j = 0; j < arglen; ++j) {
            if (arg[j] == '\'')
                fputs("'\\''", stdout);
            else
                putchar(arg[j]);
        };
        putchar('\'');
    }

    puts(" )\n");

    return 0;
}
