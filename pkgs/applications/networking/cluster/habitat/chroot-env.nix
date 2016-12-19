# TODO: Drop once https://github.com/habitat-sh/habitat/issues/994
#       is resolved.
{ habitat, libsodium, libarchive, openssl, buildFHSUserEnv }:

buildFHSUserEnv {
    name = "habitat-sh";
    targetPkgs = pkgs: [ habitat libsodium libarchive openssl ];
    runScript = "bash";
}
