{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication {
  pname = "ntlm-theft";
  version = "0-unstable-2025-09-22";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Greenwolf";
    repo = "ntlm-theft";
    rev = "9750e537444a411e99555155b3a32fad745ae3d4";
    hash = "sha256-wahjAokAbOa9gpiLO77ZgMaqWCOH34oJBrbEqgoxz8E=";
  };

  __structuredAttrs = true;

  dependencies = with python3Packages; [
    xlsxwriter
  ];

  postPatch = ''
    # Fix broken shebang
    substituteInPlace ntlm_theft.py \
      --replace-fail "#!/usr/bin/env" "#!/usr/bin/env python3"

    # Fix file permissions as copytree normally inherits the ro permissions from the nix store which leads to unwriteable files
    sed -i '/import shutil/a shutil.copystat = lambda *args, **kwargs: None' ntlm_theft.py
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ntlm_theft.py $out/share/ntlm-theft/ntlm_theft.py

    cp -r templates $out/share/ntlm-theft/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/share/ntlm-theft/ntlm_theft.py" "$out/bin/ntlm-theft" \
      --prefix PATH : "$program_PATH" \
      --prefix PYTHONPATH : "$program_PYTHONPATH"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = "export version=0.1.0";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Tool for generating multiple types of NTLMv2 hash theft files";
    homepage = "https://github.com/Greenwolf/ntlm-theft";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "ntlm-theft";
    platforms = lib.platforms.all;
  };
}
