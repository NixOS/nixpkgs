{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "1.1.1";
in

buildGoModule {
  pname = "mjmap";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rockorager";
    repo = "mjmap";
    rev = "v${version}";
    hash = "sha256-DUAwarg2yb2f+1O1oV3aXqkzh92CFhkesCY+54LPiFM=";
  };

  vendorHash = "sha256-sZsS8q/hkA2T/8QmtKzNof0mzCuWYin227+/7k3XTM0=";

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  postBuild = ''
    make mjmap.1
  '';

  postInstall = ''
    installManPage mjmap.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sendmail‐compatible JMAP client";
    homepage = "https://git.sr.ht/~rockorager/mjmap";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.emily ];
    mainProgram = "mjmap";
    platforms = lib.platforms.unix;
  };
}
