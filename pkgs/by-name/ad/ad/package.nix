{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "ad";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "sminez";
    repo = "ad";
    rev = "refs/tags/${version}";
    hash = "sha256-c2oSQ81qCZbwUl4TqovDWm8TUqI6RdrQPvoP/FaTI/A=";
  };

  cargoHash = "sha256-VgzaAQy0z1JReMeRcX7LbbgKqrwTmnVecuLd1kyekHA=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [
    # both assume `/usr/bin/sh` exists
    "--skip=buffer::tests::try_expand_known_works::file_that_exists_abs_path"
    "--skip=buffer::tests::try_expand_known_works::file_that_exists_abs_path_with_addr"
  ];

  postInstall = ''
    installManPage doc/man/ad.1
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Adaptable text editor";
    longDescription = ''
      ad (pronounced A.D.) is an attempt at combining a modal
      editing interface of likes of vi and kakoune with the
      approach to extensibility of Plan9's Acme. Inside
      of ad text is something you can execute as well as edit.

      It is primarily intended as playground for experimenting
      with implementing various text editor features and
      currently is not at all optimised or feature complete
      enough for use as your main text editor.
    '';
    homepage = "https://github.com/sminez/ad";
    license = lib.licenses.mit;
    mainProgram = "ad";
    maintainers = with lib.maintainers; [ aleksana ];
    # rely on unix domain socket
    # https://github.com/sminez/ad/issues/28
    platforms = lib.platforms.unix;
  };
}
