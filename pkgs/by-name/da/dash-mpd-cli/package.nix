{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  protobuf,
  python3,
  bento4,
  ffmpeg,
  gpac,
  libxslt,
  shaka-packager,
  nix-update-script,
  runCommand,
  versionCheckHook,
}:

let
  # dash-mpd-cli looks for a binary named `shaka-packager`, while
  # shaka-packager provides `packager`.
  shaka-packager-wrapped = runCommand "shaka-packager-wrapped" { } ''
    mkdir -p $out/bin
    ln -s ${lib.getExe shaka-packager} $out/bin/shaka-packager
  '';

  dash-mpd-rs-patched = fetchFromGitHub {
    owner = "emarsden";
    repo = "dash-mpd-rs";
    tag = "v0.19.2";
    hash = "sha256-2Sm206ZJd1JKomL22SkGsgsPhTTfTkK9zAqua5octwY=";

    postFetch = ''
      patch -d $out -i ${./dash-mpd-rs-nix-sandbox.patch} -p 1
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dash-mpd-cli";
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "emarsden";
    repo = "dash-mpd-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6MyDKi0M5perS8NmTSKXIkY31876QSH3amUxp9ApshQ=";
  };

  prePatch = ''
    originalVersion="v$(python3 ${./cargo-locked-version.py} Cargo.lock dash-mpd)"
    patchedVersion="${dash-mpd-rs-patched.tag}"
    if [[ "$patchedVersion" != "$originalVersion" ]]; then
      echo "error: dash-mpd-rs-patched should be $originalVersion, not $patchedVersion!"
      exit 1
    fi
  '';

  # Use a patched version of the dash-mpd-rs crate to allow /nix in the sandbox.
  patches = [ ./use-patched-dash-mpd-rs.patch ];

  postPatch = ''
    ln -s ${dash-mpd-rs-patched} dash-mpd-rs
  '';

  cargoHash = "sha256-aXKSO9fz4111FIiPndmEjqwogF1/NSQ9eZfFCb3rsb0=";

  buildFeatures = lib.optionals stdenv.hostPlatform.isLinux [ "sandbox" ];

  nativeBuildInputs = [
    makeWrapper
    protobuf
    python3
  ];

  # The tests depend on network access.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/dash-mpd-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          bento4
          ffmpeg
          gpac
          libxslt
          shaka-packager-wrapped
        ]
      }
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Download media content from a DASH-MPEG or DASH-WebM MPD manifest";
    longDescription = ''
      A commandline application for downloading media content from a DASH MPD
      file, as used for on-demand replay of TV content and video streaming
      services.
    '';
    homepage = "https://emarsden.github.io/dash-mpd-cli/";
    downloadPage = "https://github.com/emarsden/dash-mpd-cli/releases";
    changelog = "https://github.com/emarsden/dash-mpd-cli/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ al3xtjames ];
    mainProgram = "dash-mpd-cli";
  };
})
