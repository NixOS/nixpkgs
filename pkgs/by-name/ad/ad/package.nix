{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "ad";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sminez";
    repo = "ad";
    tag = version;
    hash = "sha256-t9zhNAmUkjjVabaBlP/dGMHY11lxC3qqg0N0HK4nz2I=";
  };

  cargoHash = "sha256-T1y7Xnyhet3a/Obb4RJ+iJE4wWpmQf0fnhxfTzM6dm0=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [
    # both assume `/usr/bin/sh` exists
    "--skip=buffer::tests::try_expand_known_works::file_that_exists_abs_path"
    "--skip=buffer::tests::try_expand_known_works::file_that_exists_abs_path_with_addr"
    # integration tests require filesystem and Unix socket access
    "--skip=editor_scenarios::"
  ];

  postInstall = ''
    installManPage docs/man/ad.1
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
