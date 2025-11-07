{
  seclists,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "rockyou";
  inherit (seclists) version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wordlists/
    tar -xvzf ${seclists}/share/wordlists/seclists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C $out/share/wordlists/

    runHook postInstall
  '';

  meta = seclists.meta // {
    description = "Famous wordlist often used for brute force attacks";
  };
}
