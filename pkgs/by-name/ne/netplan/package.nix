{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  pandoc,
  systemd,
  libyaml,
  python3,
  libuuid,
  bash-completion,
  meson,
  ninja,
  cmake,
  iproute2,
  makeWrapper,
  lib,
  nixosTests,
}:

let
  pythonenv = python3.withPackages (
    p: with p; [
      pyyaml
      cffi
      setuptools
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netplan";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "netplan";
    rev = finalAttrs.version;
    hash = "sha256-3gvTQGQxQoQWfrcsVEF0ekdCjldRL6gh3k23NIXXZCQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pythonenv
    pkg-config
    pandoc
    meson
    ninja
    cmake
    makeWrapper
  ];

  buildInputs = [
    pythonenv
    systemd
    glib
    libyaml
    libuuid
    bash-completion
    iproute2
  ];

  env.PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR = "${placeholder "out"}/share/bash-completion/completions";
  env.PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMGENERATORDIR = "${placeholder "out"}/lib/systemd/system-generators";
  env.PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  postPatch = ''
    substituteInPlace netplan-configure.service \
      --replace-fail "/usr/libexec/netplan/" "${placeholder "out"}/libexec/netplan/"
    substituteInPlace netplan_cli/cli/utils.py \
      --replace-fail "/usr/libexec/netplan/" "${placeholder "out"}/libexec/netplan/"
  '';

  # Wrap the systemd generator to force its argv0 value, ensuring it detects itself being invoked as such
  # As netplan installs a systemd generator to function, it requires `systemd.packages = [ pkgs.netplan ];` to make systemd use it
  postFixup = ''
    wrapProgram $out/bin/netplan \
      --prefix PYTHONPATH : "$out/${pythonenv.sitePackages}:${pythonenv}/${pythonenv.sitePackages}" \
      --prefix LD_LIBRARY_PATH : "$out/lib" \
      --prefix PATH : "${lib.makeBinPath [ iproute2 ]}" \
      --inherit-argv0
    wrapProgram $out/lib/systemd/system-generators/netplan \
      --argv0 /etc/systemd/system-generators/netplan
  '';

  mesonFlags = [
    (lib.mesonBool "testing" false)
  ];

  passthru.tests = {
    inherit (nixosTests) netplan;
  };

  meta = {
    description = "Backend-agnostic network configuration in YAML";
    homepage = "https://netplan.io";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
    platforms = lib.platforms.linux;
    mainProgram = "netplan";
  };
})
