{ lib, stdenv, fetchurl, fetchpatch, python3Packages, makeWrapper, gettext
, re2Support ? true
, rustSupport ? stdenv.hostPlatform.isLinux, rustPlatform
, guiSupport ? false, tk ? null
, ApplicationServices
}:

let
  inherit (python3Packages) docutils python fb-re2;

in python3Packages.buildPythonApplication rec {
  pname = "mercurial";
  version = "5.8";

  src = fetchurl {
    url = "https://mercurial-scm.org/release/mercurial-${version}.tar.gz";
    sha256 = "17rhlmmkqz5ll3k68jfzpcifg3nndbcbc2nx7kw8xn3qcj7nlpgw";
  };

  patches = [
    # https://phab.mercurial-scm.org/D10638, needed for below patch to apply
    (fetchpatch {
      url = "https://www.mercurial-scm.org/repo/hg/raw-rev/c365850b611490a5fdb235eb1cea310a542c2f84";
      sha256 = "1gn3xvahbjdhbglffqpmj559w1bkqqsk70wqcanwv7nh972aqy9g";
    })
    # https://phab.mercurial-scm.org/D10639, fixes https://bz.mercurial-scm.org/show_bug.cgi?id=6514
    (fetchpatch {
      url = "https://www.mercurial-scm.org/repo/hg/raw-rev/c8f62920f07a40af3403ba9aefa1dac8a97d53ea";
      sha256 = "1kw0xjg2c4jby0ncarjvpa5qafsyl1wzbk6jxls4hnxlxdl53nmn";
    })
  ];

  format = "other";

  passthru = { inherit python; }; # pass it so that the same version can be used in hg2git

  cargoDeps = if rustSupport then rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1kc2giqvfwsdl5fb0qmz96ws1gdrs3skfdzvpiif2i8f7r4nqlhd";
    sourceRoot = "${pname}-${version}/rust";
  } else null;
  cargoRoot = if rustSupport then "rust" else null;

  propagatedBuildInputs = lib.optional re2Support fb-re2;
  nativeBuildInputs = [ makeWrapper gettext ]
    ++ lib.optionals rustSupport (with rustPlatform; [
         cargoSetupHook
         rust.cargo
         rust.rustc
       ]);
  buildInputs = [ docutils ]
    ++ lib.optionals stdenv.isDarwin [ ApplicationServices ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optional rustSupport "PURE=--rust";

  postInstall = (lib.optionalString guiSupport ''
    mkdir -p $out/etc/mercurial
    cp contrib/hgk $out/bin
    cat >> $out/etc/mercurial/hgrc << EOF
    [extensions]
    hgk=$out/lib/${python.libPrefix}/site-packages/hgext/hgk.py
    EOF
    # setting HG so that hgk can be run itself as well (not only hg view)
    WRAP_TK=" --set TK_LIBRARY ${tk}/lib/${tk.libPrefix}
              --set HG $out/bin/hg
              --prefix PATH : ${tk}/bin "
  '') + ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        $WRAP_TK
    done

    # copy hgweb.cgi to allow use in apache
    mkdir -p $out/share/cgi-bin
    cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
    chmod u+x $out/share/cgi-bin/hgweb.cgi

    # install bash/zsh completions
    install -v -m644 -D contrib/bash_completion $out/share/bash-completion/completions/_hg
    install -v -m644 -D contrib/zsh_completion $out/share/zsh/site-functions/_hg
  '';

  meta = with lib; {
    inherit version;
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = "https://www.mercurial-scm.org";
    downloadPage = "https://www.mercurial-scm.org/release/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lukegb ];
    updateWalker = true;
    platforms = platforms.unix;
  };
}
