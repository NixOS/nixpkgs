final: prev:
prev.virglrenderer.overrideAttrs (oldAttrs: {
  version = "0.10.4d";
  src = prev.fetchurl {
    url = "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/${oldAttrs.version}-krunkit/virglrenderer-${oldAttrs.version}-krunkit.tar.bz2";
    hash = "sha256-M/buj97QUeY6CYeW0VICD5F6FBPi9ATPGHpNA48xL3o=";
  };

  buildInputs = with prev; [
    libepoxy
    moltenvk.dev
    vulkan-headers
  ];

  mesonFlags = [
    (prev.lib.mesonBool "venus" true)
    (prev.lib.mesonBool "render-server" false)
    (prev.lib.mesonEnable "drm" false)
  ];
})
