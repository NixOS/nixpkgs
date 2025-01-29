{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  python3Packages,
  asciidoc,
  wrapGAppsNoGuiHook,
  iw,
}:

stdenv.mkDerivation rec {
  pname = "networkd-dispatcher";
  version = "2.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "craftyguy";
    repo = pname;
    rev = version;
    hash = "sha256-yO9/HlUkaQmW/n9N3vboHw//YMzBjxIHA2zAxgZNEv0=";
  };

  patches = [
    # Support rule files in NixOS store paths. Required for the networkd-dispatcher
    # module to work
    ./support_nix_store_path.patch

    # Fixes: networkd-dispatcher.service: Got notification message from PID XXXX, but reception only permitted for main PID XXXX
    (fetchpatch {
      url = "https://gitlab.com/craftyguy/networkd-dispatcher/-/commit/4796368d88da516fafda321d8565ae8ccf465120.patch";
      hash = "sha256-RAoCSmZCjTXxVKesatWjiePY4xECGn5pwvOOV0clL+Q=";
    })
  ];

  postPatch = ''
    # Fix paths in systemd unit file
    substituteInPlace networkd-dispatcher.service \
      --replace "/usr/bin/networkd-dispatcher" "$out/bin/networkd-dispatcher"
    # Remove conditions on existing rules path
    sed -i '/ConditionPathExistsGlob/g' networkd-dispatcher.service
  '';

  nativeBuildInputs = [
    asciidoc
    wrapGAppsNoGuiHook
    python3Packages.wrapPython
  ];

  dontWrapGApps = true;

  checkInputs = with python3Packages; [
    dbus-python
    iw
    mock
    pygobject3
    pytestCheckHook
  ];

  pythonPath = with python3Packages; [
    configparser
    dbus-python
    pygobject3
  ];

  installPhase = ''
    runHook preInstall
    install -D -m755 -t $out/bin networkd-dispatcher
    install -Dm644 networkd-dispatcher.service $out/lib/systemd/system/networkd-dispatcher.service
    install -Dm644 networkd-dispatcher.conf $out/etc/conf.d/networkd-dispatcher.conf
    install -D networkd-dispatcher.8 -t $out/share/man/man8/
    runHook postInstall
  '';

  doCheck = true;

  preFixup = ''
    makeWrapperArgs+=( \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : "${lib.makeBinPath [ iw ]}" \
    )
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Dispatcher service for systemd-networkd connection status changes";
    mainProgram = "networkd-dispatcher";
    homepage = "https://gitlab.com/craftyguy/networkd-dispatcher";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
