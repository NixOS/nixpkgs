{ buildGoModule
, fetchFromGitHub
, lib
, pkg-config
, webkitgtk_4_1
, glib
, fuse
, installShellFiles
, wrapGAppsHook3
, glib-networking
, wrapperDir ? "/run/wrappers/bin"
}:
let
  pname = "onedriver";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "jstaf";
    repo = "onedriver";
    rev = "v${version}";
    hash = "sha256-mA5otgqXQAw2UYUOJaC1zyJuzEu2OS/pxmjJnWsVdxs=";
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-OOiiKtKb+BiFkoSBUQQfqm4dMfDW3Is+30Kwcdg8LNA=";

  nativeBuildInputs = [ pkg-config installShellFiles wrapGAppsHook3 ];
  buildInputs = [ webkitgtk_4_1 glib fuse glib-networking ];

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

    install -Dm644 ./pkg/resources/onedriver.desktop $out/share/applications/onedriver.desktop
    install -Dm644 ./pkg/resources/onedriver@.service $out/lib/systemd/user/onedriver@.service

    mkdir -p $out/share/man/man1
    installManPage ./pkg/resources/onedriver.1

    substituteInPlace $out/share/applications/onedriver.desktop \
      --replace "/usr/bin/onedriver-launcher" "$out/bin/onedriver-launcher" \
      --replace "/usr/share/icons" "$out/share/icons"

    substituteInPlace $out/lib/systemd/user/onedriver@.service \
      --replace "/usr/bin/onedriver" "$out/bin/onedriver" \
      --replace "/usr/bin/fusermount" "${wrapperDir}/fusermount"
  '';

  meta = with lib; {
    description = "A network filesystem for Linux";
    longDescription = ''
      onedriver is a network filesystem that gives your computer direct access to your files on Microsoft OneDrive.
      This is not a sync client. Instead of syncing files, onedriver performs an on-demand download of files when
      your computer attempts to use them. onedriver allows you to use files on OneDrive as if they were files on
      your local computer.
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.massimogengarelli ];
    platforms = platforms.linux;
  };
}
