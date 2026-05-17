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
}:

let
  pythonenv = python3.withPackages (
    p: with p; [
      pyyaml
      netifaces
      dbus-python
      rich
      cffi
      setuptools
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netplan";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "netplan";
    rev = finalAttrs.version;
    hash = "sha256-JbwBnv+vaSyeFd8FKAgLeYNBELAsloUIPwd1ed2ogaI=";
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
    for mesonBooleanOption in "testing" "unit_testing"; do
      substituteInPlace meson_options.txt --replace-fail \
        "option('$mesonBooleanOption', type: 'boolean', value: true)" \
        "option('$mesonBooleanOption', type: 'boolean', value: false)"
    done
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
      --inherit-argv0
    wrapProgram $out/lib/systemd/system-generators/netplan \
      --argv0 /etc/systemd/system-generators/netplan
  '';

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  meta = {
    description = "Backend-agnostic network configuration in YAML";
    homepage = "https://netplan.io";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
    platforms = lib.platforms.linux;
    mainProgram = "netplan";
  };
})
