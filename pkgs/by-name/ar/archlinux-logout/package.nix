{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  betterlockscreen,
  gobject-introspection,
  libwnck,
  bash,
}:

python3Packages.buildPythonApplication rec {
  pname = "archlinux-logout";
  version = "24.04-01";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "arcolinux";
    repo = "archlinux-logout";
    tag = version;
    hash = "sha256-zSsZsI6mPK7zzfHi00jahO4sAZ4bO2z13DjIom0ouQA=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    bash
    libwnck
  ];

  dependencies = with python3Packages; [
    pygobject3
    distro
    psutil
    pycairo
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 usr/bin/archlinux-logout $out/bin/archlinux-logout
    install -Dm755 usr/bin/archlinux-betterlockscreen $out/bin/archlinux-betterlockscreen
    cp -r usr/share $out/share
    chmod +x  $out/share/archlinux-betterlockscreen/archlinux-betterlockscreen.py
    chmod +x  $out/share/archlinux-logout/archlinux-logout.py
    sed -i '1i #!/usr/bin/env python3' $out/share/archlinux-logout/archlinux-logout.py
    install -Dm644 etc/archlinux-logout.conf $out/etc/archlinux-logout.conf
    substituteInPlace $out/bin/archlinux-betterlockscreen \
      --replace-fail "python3 /usr/share/archlinux-betterlockscreen/archlinux-betterlockscreen.py" '${placeholder "out"}/share/archlinux-betterlockscreen/archlinux-betterlockscreen.py $@'
    substituteInPlace $out/bin/archlinux-logout \
      --replace-fail "python3 /usr/share/archlinux-logout/archlinux-logout.py" '${placeholder "out"}/share/archlinux-logout/archlinux-logout.py $@' \
      --replace-fail " sh" " bash"
    substituteInPlace $out/share/applications/archlinux-betterlockscreen.desktop \
      --replace-fail "/usr/bin/" ""
    substituteInPlace $out/share/archlinux-logout/Functions.py \
      --replace-fail "parents[3]" "parents[2]" \
      --replace-fail '"/usr/bin/betterlockscreen"' "True"
    patchShebangs $out/bin

    runHook postInstall
  '';

  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath [ betterlockscreen ]}"
  ];

  postFixup = ''
    wrapPythonProgramsIn $out/share/archlinux-logout "$out $pythonPath"
    wrapPythonProgramsIn $out/share/archlinux-betterlockscreen "$out $pythonPath"
  '';

  meta = {
    description = "Widget displaying a transparent window allowing quick access to various power features";
    homepage = "https://github.com/arcolinux/archlinux-logout";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "archlinux-logout";
    maintainers = with lib.maintainers; [ powwu ];
  };
}
