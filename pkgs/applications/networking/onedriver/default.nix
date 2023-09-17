{ buildGoModule
, fetchFromGitHub
, lib
, pkg-config
, webkitgtk
, glib
, fuse
, installShellFiles
}:

buildGoModule rec {
  pname = "onedriver";
  version = "0.13.0-2";

  src = fetchFromGitHub {
      owner = "jstaf";
      repo = "onedriver";
      rev = "v${version}";
      hash = "sha256-Bcjgmx9a4pTRhkzR3tbOB6InjvuH71qomv4t+nRNc+w=";
  };

  vendorHash = "sha256-OOiiKtKb+BiFkoSBUQQfqm4dMfDW3Is+30Kwcdg8LNA=";

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ webkitgtk glib fuse ];

  ldflags = ["-X github.com/jstaf/onedriver/cmd/common.commit=v${version}"];

  subPackages = [
    "cmd/onedriver"
    "cmd/onedriver-launcher"
  ];

  postInstall = ''
    echo "Running postInstall"
    install -Dm644 ./resources/onedriver.svg $out/share/icons/onedriver/onedriver.svg
    install -Dm644 ./resources/onedriver.png $out/share/icons/onedriver/onedriver.png
    install -Dm644 ./resources/onedriver-128.png $out/share/icons/onedriver/onedriver-128.png

    install -Dm644 ./resources/onedriver.desktop $out/share/applications/onedriver.desktop

    mkdir -p $out/share/man/man1
    installManPage ./resources/onedriver.1

    substituteInPlace $out/share/applications/onedriver.desktop \
      --replace "/usr/bin/onedriver-launcher" "$out/bin/onedriver-launcher" \
      --replace "/usr/share/icons" "$out/share/icons"
  '';

  meta = with lib; {
    description = "Onedriver is a network filesystem for Linux";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = licenses.gpl3;
    maintainers = [ maintainers.massimogengarelli ];
  };
}
