# the perl and python commands of git are in its out output, so its bin
# output is minimal. Use gitBootstrap where a dependency on rustc is a cycle.
{ git }: git.bin
