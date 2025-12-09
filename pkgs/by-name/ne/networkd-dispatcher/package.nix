{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  installShellFiles,
  python3Packages,
  python3,
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
    repo = "networkd-dispatcher";
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
      --replace-fail "/usr/bin/networkd-dispatcher" "$out/bin/networkd-dispatcher"
    # Remove conditions on existing rules path
    sed -i '/ConditionPathExistsGlob/g' networkd-dispatcher.service
  '';

  nativeBuildInputs = [
    asciidoc # for a2x
    installShellFiles
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    (python3.withPackages (ps: [
      ps.dbus-python
      ps.pygobject3
    ]))
  ];

  checkInputs = with python3Packages; [
    dbus-python
    iw
    mock
    pygobject3
    pytestCheckHook
  ];

  installPhase = ''
    runHook preInstall
    install -D -m755 -t $out/bin networkd-dispatcher
    patchShebangs --host $out/bin/networkd-dispatcher
    install -Dm644 networkd-dispatcher.service $out/lib/systemd/system/networkd-dispatcher.service
    install -Dm644 networkd-dispatcher.conf $out/etc/conf.d/networkd-dispatcher.conf
    installManPage networkd-dispatcher.8
    runHook postInstall
  '';

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=("--prefix" "PATH" ":" "${lib.makeBinPath [ iw ]}")
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
