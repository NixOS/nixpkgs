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
  version = "1.0.1";
in

buildGoModule {
  pname = "mjmap";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rockorager";
    repo = "mjmap";
    rev = "v${version}";
    hash = "sha256-VV+bZ01l+uEe3wqdYyVwpzsZJNzoTCD38F6a58dozbg=";
  };

  vendorHash = "sha256-sZsS8q/hkA2T/8QmtKzNof0mzCuWYin227+/7k3XTM0=";

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "mjmap";

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
