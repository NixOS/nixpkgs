{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication {
  pname = "ntlm_theft";
  version = "0-unstable-2025-09-22";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Greenwolf";
    repo = "ntlm_theft";
    rev = "9750e537444a411e99555155b3a32fad745ae3d4";
    hash = "sha256-wahjAokAbOa9gpiLO77ZgMaqWCOH34oJBrbEqgoxz8E=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    xlsxwriter
  ];

  prePatch = ''
    # Fix broken shebang
    substituteInPlace ntlm_theft.py \
      --replace "#!/usr/bin/env " "#!/usr/bin/env python3"

    # Fix file permissions as copytree normally inherits the ro permissions from the nix store which leads to unwriteable files
    sed -i '/import shutil/a shutil.copystat = lambda *args, **kwargs: None' ntlm_theft.py
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ntlm_theft.py $out/bin/ntlm_theft

    mkdir -p $out/share/ntlm_theft/

    cp -r templates $out/share/ntlm_theft/
    ln -s $out/share/ntlm_theft/templates $out/bin/templates

    runHook postInstall
  '';

  meta = {
    description = "A tool for generating multiple types of NTLMv2 hash theft files";
    homepage = "https://github.com/Greenwolf/ntlm_theft";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "ntlm_theft";
    platforms = lib.platforms.all;
  };
}
