#!/bin/bash

# Some project files look for F# targets in $(FSharpTargetsPath)
# so it's a good idea to add something like this to your ~/.bash_profile:

# export FSharpTargetsPath=$(dirname $(which fsharpc))/../lib/mono/4.0/Microsoft.FSharp.Targets

# In build scripts, you would add somehting like this:

# export FSharpTargetsPath="${fsharp}/lib/mono/4.0/Microsoft.FSharp.Targets"

# However, some project files look for F# targets in the main Mono directory. When that happens
# patch the project files using this script so they will look in $(FSharpTargetsPath) instead.

echo "Patching F# targets in fsproj files..."

find -iname \*.fsproj -print -exec \
  sed --in-place=.bak \
    -e 's,<FSharpTargetsPath>\([^<]*\)</FSharpTargetsPath>,<FSharpTargetsPath Condition="Exists('\'\\1\'')">\1</FSharpTargetsPath>,'g \
    {} \;
