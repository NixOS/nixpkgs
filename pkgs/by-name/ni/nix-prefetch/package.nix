{ lib, stdenv, fetchFromGitHub, fetchpatch, installShellFiles, makeWrapper, asciidoc
, docbook_xml_dtd_45, git, docbook_xsl, libxml2, libxslt, coreutils, gawk
, gnugrep, gnused, jq, nix }:

stdenv.mkDerivation rec {
  pname = "nix-prefetch";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-prefetch";
    rev = version;
    sha256 = "0bwv6x651gyq703pywrhb7lfby6xwnd1iwnrzzjihipn7x3v2hz9";
    # the stat call has to be in a subshell or we get the current date
    postFetch = ''
      echo $(stat -c %Y $out) > $out/.timestamp
    '';
  };

  patches = [
    (fetchpatch {
      name = "fix-prefetching-hash-key.patch";
      url = "https://github.com/msteen/nix-prefetch/commit/508237f48f7e2d8496ce54f38abbe57f44d0cbca.patch";
      hash = "sha256-9SYPcRFZaVyNjMUVdXbef5eGvLp/kr379eU9lG5GgE0=";
    })
  ];

  postPatch = ''
    lib=$out/lib/${pname}

    substituteInPlace doc/nix-prefetch.1.asciidoc \
      --subst-var-by version $version

    substituteInPlace src/main.sh \
      --subst-var-by lib $lib \
      --subst-var-by version $version

    substituteInPlace src/tests.sh \
      --subst-var-by bin $out/bin
  '';

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    installShellFiles
    libxml2
    libxslt
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    a2x -a revdate=$(date --utc --date=@$(cat $src/.timestamp) +%d/%m/%Y) \
      -f manpage doc/nix-prefetch.1.asciidoc
  '';

  installPhase = ''
    install -Dm555 -t $lib src/*.sh
    install -Dm444 -t $lib lib/*
    makeWrapper $lib/main.sh $out/bin/${pname} \
      --prefix PATH : ${lib.makeBinPath [ coreutils gawk git gnugrep gnused jq nix ]}

    installManPage doc/nix-prefetch.?

    installShellCompletion --name ${pname} contrib/nix-prefetch-completion.{bash,zsh}

    mkdir -p $out/share/doc/${pname}/contrib
    cp -r contrib/hello_rs $out/share/doc/${pname}/contrib
  '';

  meta = with lib; {
    description = "Prefetch any fetcher function call, e.g. package sources";
    license = licenses.mit;
    maintainers = with maintainers; [ msteen ];
    homepage = "https://github.com/msteen/nix-prefetch";
    platforms = platforms.all;
    mainProgram = "nix-prefetch";
  };
}
