{
  buildGoModule,
  fetchFromGitHub,
  lib,
  pkg-config,
  webkitgtk_4_1,
  glib,
  fuse,
  installShellFiles,
  wrapGAppsHook3,
  glib-networking,
  wrapperDir ? "/run/wrappers/bin",
}:
let
  pname = "onedriver";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "jstaf";
    repo = "onedriver";
    rev = "v${version}";
    hash = "sha256-DCxF52CtA9KAP+yz5Rgzc/nUAXtZwfYAVU7oHREJlRY=";
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-Ifcmf9AtZnrjgTPQnof/ap0TY19zHVftm5N4JgvbAgs=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    wrapGAppsHook3
  ];
  buildInputs = [
    webkitgtk_4_1
    glib
    fuse
    glib-networking
  ];

  ldflags = [ "-X github.com/jstaf/onedriver/cmd/common.commit=v${version}" ];

  subPackages = [
    "cmd/onedriver"
    "cmd/onedriver-launcher"
  ];

  postInstall = ''
    echo "Running postInstall"
    install -Dm644 ./pkg/resources/onedriver.svg $out/share/icons/onedriver/onedriver.svg
    install -Dm644 ./pkg/resources/onedriver.png $out/share/icons/onedriver/onedriver.png
    install -Dm644 ./pkg/resources/onedriver-128.png $out/share/icons/onedriver/onedriver-128.png

    install -Dm644 ./pkg/resources/onedriver-launcher.desktop $out/share/applications/onedriver-launcher.desktop
    install -Dm644 ./pkg/resources/onedriver@.service $out/lib/systemd/user/onedriver@.service

    mkdir -p $out/share/man/man1
    installManPage ./pkg/resources/onedriver.1

    substituteInPlace $out/share/applications/onedriver-launcher.desktop \
      --replace-fail "/usr/bin/onedriver-launcher" "$out/bin/onedriver-launcher" \
      --replace-fail "/usr/share/icons" "$out/share/icons"

    substituteInPlace $out/lib/systemd/user/onedriver@.service \
      --replace-fail "/usr/bin/onedriver" "$out/bin/onedriver" \
      --replace-fail "/usr/bin/fusermount" "${wrapperDir}/fusermount"
  '';

  meta = {
    description = "Network filesystem for Linux";
    longDescription = ''
      onedriver is a network filesystem that gives your computer direct access to your files on Microsoft OneDrive.
      This is not a sync client. Instead of syncing files, onedriver performs an on-demand download of files when
      your computer attempts to use them. onedriver allows you to use files on OneDrive as if they were files on
      your local computer.
    '';
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = [
      lib.maintainers.massimogengarelli
      lib.maintainers.lnk3
    ];
    platforms = lib.platforms.linux;
  };
}
