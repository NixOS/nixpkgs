{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  installShellFiles,
  nixosTests,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fail2ban";
  version = "1.1.1";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fail2ban";
    repo = "fail2ban";
    tag = finalAttrs.version;
    hash = "sha256-6L8lSoFdf/KL1AQfN0lfGthEfeLlxodVsMI3LXCq+XY=";
  };

  outputs = [
    "out"
    "man"
  ]
  # From some reason upstream installs documentation only for Linux, solaris,
  # sunos and any gnu system.
  ++ lib.optionals (lib.pipe stdenv.hostPlatform [
    (lib.attrVals [
      "isLinux"
      "isSunOS"
      "isGnu"
    ])
    (builtins.any lib.id)
  ]) [ "doc" ];

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies =
    with python3.pkgs;
    lib.optionals stdenv.hostPlatform.isLinux [
      systemd-python
      pyinotify
    ];

  preConfigure = ''
    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail
    done
  '';

  doCheck = false;

  patches = [
    # fixes for systemd socket activation - remove next release
    (fetchpatch {
      url = "https://github.com/fail2ban/fail2ban/commit/403df4a91c8ad8f235a3cb9e17d0cc4d29c2dafd.patch";
      hash = "sha256-HI/9qaB+TMbRu/2NPwV+kVcYK03YNnzcD+iaBOlM20w=";
      # causes merge conflicts
      excludes = [ "ChangeLog" ];
    })
  ];

  preInstall = ''
    substituteInPlace setup.py --replace /usr/share/doc/ share/doc/

    # see https://github.com/NixOS/nixpkgs/issues/4968
    ${python3.pythonOnBuildForHost.interpreter} setup.py install_data --install-dir=$out --root=$out
  '';

  postInstall =
    let
      sitePackages = "$out/${python3.sitePackages}";
    in
    ''
      install -m 644 -D -t "$out/lib/systemd/system" build/fail2ban.service build/fail2ban.socket
      # Replace binary paths
      sed -i "s#build/bdist.*/wheel/fail2ban.*/scripts/#$out/bin/#g" $out/lib/systemd/system/fail2ban.service

      # see https://github.com/NixOS/nixpkgs/issues/4968
      rm -r "${sitePackages}/etc"

      installManPage man/*.[1-9]

      # This is a symlink to the build python version created by `updatePyExec`, seemingly to assure the same python version is used?
      rm $out/bin/fail2ban-python
      ln -s ${python3.interpreter} $out/bin/fail2ban-python

      # Irrelevant for NixOS
      rm -r $out/var
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # see https://github.com/NixOS/nixpkgs/issues/4968
      rm -r "${sitePackages}/usr"
    '';

  passthru.tests = { inherit (nixosTests) fail2ban; };

  meta = {
    homepage = "https://www.fail2ban.org/";
    description = "Program that scans log files for repeated failing login attempts and bans IP addresses";
    changelog = "https://github.com/fail2ban/fail2ban/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Deric-W
    ];
  };
})
