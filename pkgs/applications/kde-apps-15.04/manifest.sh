#!/bin/sh

if [ $# -eq 0 ]; then

  # The extra slash at the end of the URL is necessary to stop wget
  # from recursing over the whole server! (No, it's not a bug.)
  $(nix-build ../../.. -A autonix.manifest) \
      # We need 14.12 for some packages in LTS that are not released in beta.
      # Remove 14.12 when 15.04 is out of beta.
      http://download.kde.org/stable/applications/14.12.1/ \
      http://download.kde.org/stable/applications/14.12.2/ \
      http://download.kde.org/stable/applications/14.12.3/ \
      http://download.kde.org/unstable/applications/15.03.97/ \
      -A '*.tar.xz'

else

  $(nix-build ../../.. -A autonix.manifest) -A '*.tar.xz' "$@"

fi
