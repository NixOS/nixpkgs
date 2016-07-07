# TODO: Drop once https://github.com/habitat-sh/habitat/issues/994
#       is resolved.
{ habitat, libsodium, libarchive, openssl, buildFHSUserEnv }:

buildFHSUserEnv {
    name = "hab";
    targetPkgs = pkgs: [ habitat libsodium libarchive openssl ];
    runScript = "bash";
}
