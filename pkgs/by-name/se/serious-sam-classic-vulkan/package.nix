{
  libx11,
  libxcb,
  serious-sam-classic,
  vulkan-headers,
  vulkan-loader,
}:
serious-sam-classic.overrideAttrs (oldAttrs: {
  pname = "serious-sam-classic-vulkan";

  src = oldAttrs.src.override {
    repo = "SeriousSamClassic-VK";
    hash = "sha256-fnWJOmgaW4/PfrmXiN7qodHEXc96/AZCbUo3dwelY6s=";
  };

  buildInputs = oldAttrs.buildInputs ++ [
    libxcb
    vulkan-headers
    vulkan-loader
    libx11.dev
  ];
})
