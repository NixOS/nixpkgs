{ asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, fetchFromGitHub
, gawk
, git
, gnused
, lib
, makeWrapper
, openssl
, perl
, stdenv
, xmlto
}:

stdenv.mkDerivation rec {
  pname = "guilt";
  version = "0.37-rc1";

  src = fetchFromGitHub {
    owner = "jeffpc";
    repo = "guilt";
    rev = "v${version}";
    sha256 = "sha256-7OgRbMGYWtGvrZxKfJe0CkpmU3AUkPebF5NyTsfXeGA=";
  };

  doCheck = true;

  patches = [
    ./guilt-help-mandir.patch
    ./darwin-fix.patch
  ];
  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
    perl
    xmlto
  ];
  buildInputs = [
    gawk
    git
    gnused
  ] ++ lib.optionals stdenv.isDarwin [ openssl ];
  makeFlags = [
    "PREFIX=$(out)"
  ];

  postBuild = ''
    make -j $NIX_BUILD_CORES doc
  '';

  preCheck = ''
    patchShebangs regression/run-tests regression/*.sh
  '';

  postInstall = ''
    make PREFIX=$out install-doc
  '';

  postFixup = ''
    wrapProgram $out/bin/guilt --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    description = "Manage patches like quilt, on top of a git repository";
    longDescription = ''
      Andrew Morton originally developed a set of scripts for
      maintaining kernel patches outside of any SCM tool. Others
      extended these into a suite called quilt]. The basic idea behind
      quilt is to maintain patches instead of maintaining source
      files. Patches can be added, removed or reordered, and they can
      be refreshed as you fix bugs or update to a new base
      revision. quilt is very powerful, but it is not integrated with
      the underlying SCM tools. This makes it difficult to visualize
      your changes.

      Guilt allows one to use quilt functionality on top of a Git
      repository. Changes are maintained as patches which are
      committed into Git. Commits can be removed or reordered, and the
      underlying patch can be refreshed based on changes made in the
      working directory. The patch directory can also be placed under
      revision control, so you can have a separate history of changes
      made to your patches.
    '';
    homepage = "https://github.com/jeffpc/guilt";
    maintainers = with lib.maintainers; [ javimerino ];
    license = [ licenses.gpl2 ];
    platforms = platforms.all;
    mainProgram = "guilt";
  };
}
