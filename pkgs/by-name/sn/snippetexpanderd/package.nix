{ lib
, stdenv
, buildGoModule
, fetchFromSourcehut
, pkg-config
, makeWrapper
, scdoc
, installShellFiles
, xorg
, gtk3
}:

buildGoModule rec {
  pname = "snippetexpanderd";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~ianmjones";
    repo = "snippetexpander";
    rev = "v${version}";
    hash = "sha256-y3TJ+L3kXYfZFzAD1vmhvP6Yarctu5LHq/74005h8sI=";
  };

  vendorHash = "sha256-QX8HI8I1ZJI6HJ1sl86OiJ4nxwFAjHH8h1zB9ASJaQs=";

  modRoot = "cmd/snippetexpanderd";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    scdoc
    installShellFiles
  ];

  buildInputs = [
    xorg.libX11
    gtk3
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    make man
    installManPage snippetexpanderd.1 snippetexpander-placeholders.5
  '';

  postFixup = ''
    wrapProgram $out/bin/snippetexpanderd \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ xorg.libX11 ]}
  '';

  meta = with lib; {
    description = "Your little expandable text snippet helper daemon";
    homepage = "https://snippetexpander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
    mainProgram = "snippetexpanderd";
  };
}
