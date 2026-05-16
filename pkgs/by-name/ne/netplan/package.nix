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
  cmocka,
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
      pyflakes
      pycodestyle
      pytest
      coverage
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

  nativeBuildInputs = [
    pkg-config
    glib
    pandoc
    meson
    ninja
    cmocka
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
    substituteInPlace meson.build \
      --replace-fail "python3-coverage" "coverage" \
      --replace-fail "pyflakes3" "pyflakes" \
      --replace-fail "pytest3" "pytest"
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
      --prefix LD_LIBRARY_PATH : "$out/lib"
    mv $out/lib/systemd/system-generators/netplan $out/lib/systemd/system-generators/.netplan-wrapped
    makeWrapper $out/lib/systemd/system-generators/.netplan-wrapped $out/lib/systemd/system-generators/netplan \
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
