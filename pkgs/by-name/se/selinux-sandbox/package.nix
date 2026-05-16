{
  lib,
  stdenv,
  fetchurl,
  gettext,
  bash,
  coreutils,
  python3,
  python3Packages,
  libcap_ng,
  policycoreutils,
  selinux-python,
  dbus,
  xorg-server,
  xwayland,
  openbox,
  xmodmap,
  libselinux,
  setools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "selinux-sandbox";
  version = "3.10";
  inherit (policycoreutils) se_url;

  src = fetchurl {
    url = "${finalAttrs.se_url}/${finalAttrs.version}/selinux-sandbox-${finalAttrs.version}.tar.gz";
    hash = "sha256-4r0T4YT3IYFVoz6pQygdAvRBwpcQQBW+69/G2Npv9cM=";
  };

  nativeBuildInputs = [
    gettext
    python3Packages.wrapPython
  ];
  buildInputs = [
    bash
    coreutils
    libcap_ng
    policycoreutils
    python3
    xorg-server
    openbox
    xmodmap
    dbus
    libselinux
  ];
  propagatedBuildInputs = [
    python3Packages.pygobject3
    selinux-python
  ];
  pythonPath = [
    python3Packages.libselinux
    setools
  ];

  postPatch = ''
    # Fix setuid install
    substituteInPlace Makefile --replace-fail "-m 4755" "-m 755"
    substituteInPlace po/Makefile --replace-fail /usr/bin/install install
    substituteInPlace sandboxX.sh \
      --replace-fail "#!/bin/bash" "#!${bash}/bin/bash" \
      --replace-fail "/usr/share/sandbox/start" "${placeholder "out"}/share/sandbox/start" \
      --replace-fail "/usr/bin/cut" "${coreutils}/bin/cut" \
      --replace-fail "/usr/bin/Xephyr" "${xorg-server}/bin/Xepyhr" \
      --replace-fail "/usr/bin/Xwayland" "${xwayland}/bin/Xwayland" \
      --replace-fail "secon" "${policycoreutils}/bin/secon"
    substituteInPlace sandbox \
      --replace-fail "/usr/sbin/seunshare" "$out/bin/seunshare" \
      --replace-fail "/usr/share/sandbox" "$out/share/sandbox" \
      --replace-fail "/usr/share/locale" "${policycoreutils}/share/locale" \
      --replace-fail "/usr/bin/openbox" "${openbox}/bin/openbox" \
      --replace-fail "#!/bin/sh" "#!${bash}/bin/sh" \
      --replace-fail "dbus-" "${dbus}/bin/dbus-" \
      --replace-fail "/usr/bin/xmodmap" "${xmodmap}/bin/xmodmap" \
      --replace-fail "/usr/bin/shred" "${coreutils}/bin/shred" \
      --replace-fail "/usr/bin/test" "${coreutils}/bin/test"
    patchShebangs --host sandboxX.sh sandbox start sandbox.init
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc/sysconfig"
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    # "sandbox: Requires a SELinux enabled system" or help, which includes sandbox
    { $out/bin/sandbox --help || true; } 2>&1 | grep -Fm1 'sandbox'
    runHook postInstallCheck
  '';

  meta = {
    mainProgram = "sandbox";
    description = "SELinux sandbox utility";
    license = lib.licenses.gpl2Only;
    homepage = "https://selinuxproject.org";
    platforms = lib.platforms.linux;
    inherit (selinux-python.meta) maintainers;
  };
})
