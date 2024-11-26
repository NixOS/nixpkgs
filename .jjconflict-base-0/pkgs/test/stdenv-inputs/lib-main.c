#include <stdio.h>

extern unsigned int foo(void);
extern unsigned int bar(void);

int main(int argc, char **argv)
{
  if (foo() != 42)
    return 1;
  if (bar() != 42)
    return 1;
  fprintf(stderr, "ok\n");
  return 0;
}
