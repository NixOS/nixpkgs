{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "findimagedupes";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "jhnc";
    repo = "findimagedupes";
    tag = version;
    hash = "sha256-LJbZGuBVksfS7nVxgrMLSeygWuy9oDmw/pD8wAyr3f0=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    perl
  ]
  ++ (with perlPackages; [
    DBFile
    FileMimeInfo
    FileBaseDir
    #GraphicsMagick
    ImageMagick
    Inline
    InlineC
    ParseRecDescent
  ]);

  # compiled files (findimagedupes.so etc) are written to $DIRECTORY/lib/auto/findimagedupes
  # replace GraphicsMagick with ImageMagick, because perl bindings are not yet available
  postPatch = ''
    substituteInPlace findimagedupes \
      --replace-fail "DIRECTORY => '/usr/local/lib/findimagedupes';" "DIRECTORY => '$out';" \
      --replace-fail "Graphics::Magick" "Image::Magick" \
      --replace-fail "my \$Id = '""';" "my \$Id = '${version}';"
  '';

  # with DIRECTORY = "/tmp":
  # $ ./result/bin/findimagedupes
  # /bin/sh: line 1: cc: command not found
  # $ strace ./result/bin/findimagedupes 2>&1 | grep findimagedupes
  # newfstatat(AT_FDCWD, "/tmp/lib/auto/findimagedupes/findimagedupes.inl", {st_mode=S_IFREG|0644, st_size=585, ...}, 0) = 0
  # newfstatat(AT_FDCWD, "/tmp/lib/auto/findimagedupes/findimagedupes.so", {st_mode=S_IFREG|0555, st_size=16400, ...}, 0) = 0
  buildPhase = "
    runHook preBuild
    # fix: Invalid value '$out' for config option DIRECTORY
    mkdir $out
    # build findimagedupes.so
    # compile inline C code (perl Inline::C) on the first run
    # fix: Can't open $out/config-x86_64-linux-thread-multi-5.040000 for output. Read-only file system
    ${lib.getExe perl} findimagedupes
    # build manpage
    ${lib.getExe' perl "pod2man"} findimagedupes > findimagedupes.1
    runHook postBuild
  ";

  installPhase = ''
    runHook preInstall
    installBin findimagedupes
    installManPage findimagedupes.1
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/findimagedupes" \
      --prefix PERL5LIB : "${
        with perlPackages;
        makePerlPath [
          DBFile
          FileMimeInfo
          FileBaseDir
          #GraphicsMagick
          ImageMagick
          Inline
          InlineC
          ParseRecDescent
        ]
      }"
  '';

  meta = {
    homepage = "http://www.jhnc.org/findimagedupes/";
    description = "Finds visually similar or duplicate images";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ stunkymonkey ];
  };
}
