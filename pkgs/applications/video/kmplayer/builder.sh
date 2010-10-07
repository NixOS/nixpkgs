source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s|files.length|files.size|" \
           -e "s|chlds.length|chlds.size|" src/kmplayerapp.cpp
}
patchPhase=myPatchPhase
genericBuild
