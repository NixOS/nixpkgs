#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { char *data; size_t len, cap; } String;

void resize(String *s, size_t len) {
    s->len = len;
    if (s->cap < s->len) {
        s->cap = s->len * 2;
        s->data = (char *)realloc(s->data, s->cap);
        assert(s->data);
    }
}

void append(String *s, const char *data, size_t len) {
    resize(s, s->len + len);
    memcpy(s->data + s->len - len, data, len);
}

typedef enum { space = 0, other = 1, backslash = 2, apostrophe = 3, quotation_mark = 4 } CharClass;
typedef enum { outside, unq, unq_esc, sq, sq_esc, dq, dq_esc } State;

// current State -> CharClass -> next State
const State transitions[][5] = {
    [outside] = {outside, unq, unq_esc, sq,  dq},
    [unq]     = {outside, unq, unq_esc, sq,  dq},
    [unq_esc] = {unq,     unq, unq,     unq, unq},
    [sq]      = {sq,      sq,  sq_esc,  unq, sq},
    [sq_esc]  = {sq,      sq,  sq,      sq,  sq},
    [dq]      = {dq,      dq,  dq_esc,  dq,  unq},
    [dq_esc]  = {dq,      dq,  dq,      dq,  dq},
};

CharClass charClass(int c) {
    return c == '\\' ? backslash : c == '\'' ? apostrophe : c == '"' ? quotation_mark :
            isspace(c) ? space : other;
}

// expandArg writes NULL-terminated expansions of `arg', a NULL-terminated
// string, to stdout.  If arg does not begin with `@' or does not refer to a
// file, it is written as is.  Otherwise the contents of the file are
// recursively expanded.  On unexpected EOF in malformed response files an
// incomplete final argument is written, even if it is empty, to parse like GCC.
void expandArg(String *arg) {
    FILE *f;
    if (arg->data[0] != '@' || !(f = fopen(&arg->data[1], "r"))) {
        fwrite(arg->data, 1, arg->len, stdout);
        return;
    }

    resize(arg, 0);
    State cur = outside;
    int c;
    do {
        c = fgetc(f);
        State next = transitions[cur][charClass(c)];
        if ((cur == unq && next == outside) || (cur != outside && c == EOF)) {
            append(arg, "", 1);
            expandArg(arg);
            resize(arg, 0);
        } else if (cur == unq_esc || cur == sq_esc || cur == dq_esc ||
                   (cur == outside ? next == unq : cur == next)) {
            char s = c;
            append(arg, &s, 1);
        }
        cur = next;
    } while (c != EOF);

    fclose(f);
}

int main(int argc, char **argv) {
    String arg = { 0 };
    while (*++argv) {
        resize(&arg, 0);
        append(&arg, *argv, strlen(*argv) + 1);
        expandArg(&arg);
    }
    free(arg.data);
    return EXIT_SUCCESS;
}
