{ lib, stdenv, fetchurl, cmake, libuuid, gnutls, python3, bash }:

stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "2.5.3";

  srcs = [
    (fetchurl {
      url = "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${version}/${sourceRoot}.tar.gz";
      sha256 = "0fwnxshhlha21hlgg5z1ad01w13zm1hlmncs274y5n8i15gdfhvj";
    })
    (fetchurl {
      url = "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${version}/tests-${version}.tar.gz";
      sha256 = "165xmf9h6rb7l6l9nlyygj0mx9bi1zyd78z0lrl3nadhmgzggv0b";
    })
  ];

  sourceRoot = "task-${version}";

  postUnpack = ''
    mv test ${sourceRoot}
  '';

  nativeBuildInputs = [ cmake libuuid gnutls ];

  doCheck = true;
  preCheck = ''
    find test -type f -exec sed -i \
      -e "s|/usr/bin/env python3|${python3.interpreter}|" \
      -e "s|/usr/bin/env bash|${bash}/bin/bash|" \
      {} +
  '';
  checkTarget = "test";

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
    mkdir -p "$out/share/fish/vendor_completions.d"
    ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/"
    mkdir -p "$out/share/zsh/site-functions"
    ln -s "../../../share/doc/task/scripts/zsh/_task" "$out/share/zsh/site-functions/"
  '';

  meta = with lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.unix;
  };
}
