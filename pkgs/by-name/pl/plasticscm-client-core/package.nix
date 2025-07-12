{
  buildFHSEnv,
  extraLibs ? _: [ ],
  extraPkgs ? _: [ ],
  lib,
  libgcc,
  libz,
  plasticscm-client-core-unwrapped,
}:
buildFHSEnv {
  pname = "plasticscm-client-core";
  inherit (plasticscm-client-core-unwrapped) version meta;

  runScript = "/usr/bin/cm";

  targetPkgs =
    pkgs:
    with pkgs;
    [
      plasticscm-client-core-unwrapped
    ]
    ++ extraPkgs pkgs;

  multiPkgs =
    pkgs:
    with pkgs;
    [
      # Dependencies from the Debian package
      glibc.out
      libgcc.lib
      libz
      krb5.lib
      lttng-ust.out
      openssl_3.out
      icu74

      # Transitive dependencies from the Debian package
      libidn2.out
      libunistring
      e2fsprogs.out
      keyutils.lib
      numactl.out
    ]
    ++ extraLibs pkgs;

  extraInstallCommands = ''
    mv $out/bin/$pname $out/bin/cm
  '';
}
