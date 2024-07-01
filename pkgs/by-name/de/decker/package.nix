{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_image
, unixtools
, multimarkdown
}:

stdenv.mkDerivation rec {
  pname = "decker";
  version = "1.44";

  src = fetchFromGitHub {
    owner = "JohnEarnest";
    repo = "Decker";
    rev = "v${version}";
    hash = "sha256-C3CWzrKhZWEud0N2p56U+zhGjwTJ5xCfZsz+NlkdQG4=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    multimarkdown
    unixtools.xxd
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs ./scripts
  '';

  buildPhase = ''
    runHook preBuild
    make lilt
    make decker
    make docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 ./c/build/lilt -t $out/bin
    install -Dm0755 ./c/build/decker -t $out/bin
    install -Dm0644 ./syntax/vim/ftdetect/lil.vim -t $out/share/vim-plugins/decker/ftdetect
    install -Dm0644 ./syntax/vim/syntax/lil.vim -t $out/share/vim-plugins/decker/syntax

    # Fixing the permissions of the installed files on the documentation.
    chmod a-x ./docs/images/* \
              ./docs/*.md \
              ./examples/decks/*.deck \
              ./examples/lilt/*.lil

    # This example has a shebang so we'll leave it as an executable.
    chmod a+x ./examples/lilt/podcasts.lil

    mkdir -p $out/share/doc/decker
    cp -r ./docs/*.html ./docs/images ./examples $out/share/doc/decker

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://beyondloom.com/decker";
    description = "Multimedia platform for creating and sharing interactive documents";
    license = licenses.mit;
    mainProgram = "decker";
    platforms = platforms.all;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
