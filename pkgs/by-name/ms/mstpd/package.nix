{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "mstpd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mstpd";
    repo = "mstpd";
    rev = version;
    hash = "sha256-m4gbVXAPIYGQvTFaSziFuOO6say5kgUsk7NSdqXgKmA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--prefix=$(out)"
    "--sysconfdir=$(out)/etc"
    "--sbindir=$(out)/bin"
    "--libexecdir=$(out)/lib"
    "--with-bashcompletiondir=$(out)/share/bash-completion/completions"
  ];

  # bridge-stp is a helper called by kernel whenever STP is enabled/disabled on
  # a bridge - we remove it, because it's not compatible with NixOS as the
  # kernel is hard-coded to look for a binary in `/sbin` that we can't provide.
  #
  # Instead, users should call `mstpd addbridge ...` etc. by hand.
  #
  # - https://github.com/mstpd/mstpd/issues/140#issuecomment-1620437872
  # - https://github.com/torvalds/linux/blob/928990631327cf00a9195e30fa22f7ae5f8d7e67/net/bridge/br_private.h#L51
  postInstall = ''
    rm $out/bin/bridge-stp

    # Remove now-dangling symlinks, too
    rm $out/bin/mstp_restart
    rm $out/lib/mstpctl-utils/mstpctl_restart_config
  '';

  meta = {
    description = "Multiple Spanning Tree Protocol daemon";
    homepage = "https://github.com/mstpd/mstpd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
