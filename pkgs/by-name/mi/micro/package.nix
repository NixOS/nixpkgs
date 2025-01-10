{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  callPackage,
  wl-clipboard,
  xclip,
  makeWrapper,
  # Boolean flags
  withXclip ? stdenv.isLinux,
  withWlClipboard ?
    if withWlclip != null then
      lib.warn ''
        withWlclip is deprecated and will be removed;
        use withWlClipboard instead.
      '' withWlclip
    else
      stdenv.isLinux,
  # Deprecated options
  # Remove them before or right after next version update from Nixpkgs or this
  # package itself
  withWlclip ? null,
}:

let
  self = buildGoModule {
    pname = "micro";
    version = "2.0.13";

    src = fetchFromGitHub {
      owner = "zyedidia";
      repo = "micro";
      rev = "v${self.version}";
      hash = "sha256-fe+7RkUwCveBk14bYzg5uLGOqTVVJsrqixBQhCS79hY=";
    };

    vendorHash = "sha256-ePhObvm3m/nT+7IyT0W6K+y+9UNkfd2kYjle2ffAd9Y=";

    nativeBuildInputs = [
      installShellFiles
      makeWrapper
    ];

    outputs = [
      "out"
      "man"
    ];

    subPackages = [ "cmd/micro" ];

    ldflags =
      let
        t = "github.com/zyedidia/micro/v2/internal";
      in
      [
        "-s"
        "-w"
        "-X ${t}/util.Version=${self.version}"
        "-X ${t}/util.CommitHash=${self.src.rev}"
      ];

    strictDeps = true;

    preBuild = ''
      GOOS= GOARCH= go generate ./runtime
    '';

    postInstall = ''
      installManPage assets/packaging/micro.1
      install -Dm444 assets/packaging/micro.desktop $out/share/applications/micro.desktop
      install -Dm644 assets/micro-logo-mark.svg $out/share/icons/hicolor/scalable/apps/micro.svg
    '';

    postFixup =
      let
        clipboardPackages =
          lib.optionals withXclip [ xclip ]
          ++ lib.optionals withWlClipboard [ wl-clipboard ];
      in
      lib.optionalString (withXclip || withWlClipboard) ''
        wrapProgram "$out/bin/micro" \
                  --prefix PATH : "${lib.makeBinPath clipboardPackages}"
      '';

    passthru = {
      tests = lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./tests;
      };
    };

    meta = {
      homepage = "https://micro-editor.github.io";
      description = "Modern and intuitive terminal-based text editor";
      longDescription = ''
        micro is a terminal-based text editor that aims to be easy to use and
        intuitive, while also taking advantage of the capabilities of modern
        terminals.

        As its name indicates, micro aims to be somewhat of a successor to the
        nano editor by being easy to install and use. It strives to be enjoyable
        as a full-time editor for people who prefer to work in a terminal, or
        those who regularly edit files over SSH.
      '';
      license = lib.licenses.mit;
      mainProgram = "micro";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
self
