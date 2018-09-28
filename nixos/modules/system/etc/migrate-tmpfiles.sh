#!/bin/sh

{
  # remove all symlinks into /etc/static
  find /etc -lname '/etc/static/*' -printf '%P\n'

  # previously-copied files are listed in /etc/.clean
  cat /etc/.clean

  # also remove the /etc/static symlink and /etc/.clean itself
  echo static
  echo .clean

} | while read f; do
  # generate almost the tmpfiles.d(5) format but with a type that doesn't
  # exist so these entries can't match anything in newly-generated configs
  prefix=.
  while test "$f" != .; do
    echo $prefix "/etc/$f"

    # also remove parent directories of any previously-created files, although
    # this will only actually happen if the directory is empty after removing
    # previously-created things inside it
    f="$(dirname "$f")"
    # but mark these as directories so we won't try to delete them if the
    # newly-generated config is going to create them again
    prefix=d
  done
done | LC_COLLATE=C sort -uk2

# if both .clean and .created exist, we have to clean up from both old and new
# style configs at the same time
cat /etc/.created 2>/dev/null || true
