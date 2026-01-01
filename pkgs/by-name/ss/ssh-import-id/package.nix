{
  lib,
  extraHandlers ? [ ],
  fetchgit,
  installShellFiles,
  makeWrapper,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ssh-import-id";
  version = "5.11";
  pyproject = true;

  src = fetchgit {
    url = "https://git.launchpad.net/ssh-import-id";
    tag = version;
    hash = "sha256-tYbaJGH59qyvjp4kwo3ZFVs0EaE0Lsd2CQ6iraFkAdI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "long_description_content_type='markdown'" "long_description_content_type='text/markdown'"
  '';

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  dependencies =
    with python3Packages;
    [
      requests
      distro
    ]
    ++ extraHandlers;

  postInstall = ''
    installManPage $src/usr/share/man/man1/ssh-import-id.1
  '';

  # Handlers require main bin, main bin requires handlers
  makeWrapperArgs = [
    "--prefix"
    ":"
    "$out/bin"
  ];

<<<<<<< HEAD
  meta = {
    description = "Retrieves an SSH public key and installs it locally";
    homepage = "https://launchpad.net/ssh-import-id";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Retrieves an SSH public key and installs it locally";
    homepage = "https://launchpad.net/ssh-import-id";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mkg20001
      viraptor
    ];
    mainProgram = "ssh-import-id";
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
