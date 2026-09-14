import ./generic.nix {
  hash = "sha256-Ivj0vWKuhgb4VvyxcuB+CXsJ02zwo65rqxD5/cLUmSk=";
  version = "7.0.1";
  vendorHash = "sha256-F3LhWVjckU0ypgOppHztjR6hDB6enHxoDmRWcSDfwQE=";
  patches = fetchpatch2: [
    # incusd/storage: Strip unsafe symlinks in externally-supplied instance data
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/136444d9b65d17a55519f1a86809f030d58c9c79.patch?full_index=1";
      hash = "sha256-mNgcLPq6liRBqLRHwMd3cgolESXx3nzYFPsqqhXtPXQ=";
    })
    # incusd/storage/s3: Reject symlinks in bucket backups
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/4dc6e1f7935ac13bcff98f6aa213e02815d0dcc8.patch?full_index=1";
      hash = "sha256-t5dM7BGGD8H/PfgDoRgP/0jIB38sK0ez0uYGjb+I9f8=";
    })
    # incusd/storage: Allow expected symlinks in instance metadata
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/001bd0657f9ea6d73368118a01c5248080f2bbef.patch?full_index=1";
      hash = "sha256-daCtygGZN1C7LIN2FGsajnUjMt/JeefrfxTC/8IhddY=";
    })
    # incusd/project: Restrict volume creation options in restricted projects
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/dbc1e36173f8cac74ef276a88ba1e0bc9964002c.patch?full_index=1";
      hash = "sha256-1fOHnNUMdIlzHZRFuAfflRT7ZlZBMlpvAhfCVUDiwls=";
    })
    # internal/instance: Prevent line breaks in NVIDIA config values
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/4f847ad5ab34716efb723e3f46e3d72e472035de.patch?full_index=1";
      hash = "sha256-O/1RoRPTzq5WxnApTE+2KeIVsDT2CSz8yX4/rqRr83Y=";
    })
    # incusd/storage: Confine backup.yaml write to instance root
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/7135f0183d9dc0661d2e3eb36779bc2273545266.patch?full_index=1";
      hash = "sha256-K/c03Qlomig8uQz/Sj/eIRNvVZweq7PNJra6ehY1u+M=";
    })
    # incusd/instance: Confine metadata.yaml access to instance root
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/1bb869273c69cd5d17558a021028c5dee45d82d4.patch?full_index=1";
      hash = "sha256-ckKR8u02s7tQm9bq9sAYC5w0HfZVSZc6q54j0lNoHOA=";
    })
    # incusd/instance/qemu: Confine template access to instance root
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/181ae5c746c718767e8ca6f3edbe3df4a6fc9fbe.patch?full_index=1";
      hash = "sha256-ccAAdn7KKc5y0ZanL78+GBWrQy5y2a/hUX8U1gYTZaQ=";
    })
    # incusd/images: Validate image fingerprint for all protocols
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/3d7246efe5ec4dba476f95ec163eb4a165717863.patch?full_index=1";
      hash = "sha256-2J9T12qFRWaX1l7pyXXucPMN3VRmUoNKoCiQfFFvieI=";
    })
    # incusd/storage: Validate volume name on ISO and backup import
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/c7cf33d46a83fd39b59843f0bd406a2c88d2e899.patch?full_index=1";
      hash = "sha256-/cgRwmWNtl2PAgqpYH3BEv6+ZrF7rH8s+yn84+ICYHU=";
    })
    # incusd/instances: Validate instance name on backup import
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/0d21c84dbff03e1a676a94ecbfaafca8b48695ba.patch?full_index=1";
      hash = "sha256-5CcxJgqBssaXcV1GviI297DgygEeJp5ZKUtDmotS3nw=";
    })
    # incusd/instances: Re-check restrictions after copy config merge
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/9bc9f9ba5ab61fd5e6c9fa0f5e2440d4ce8495e5.patch?full_index=1";
      hash = "sha256-raNNgdbIw5SzJSfIVaOEy0A7A0B98HogAIRGaX7V/Sk=";
    })
    # incusd/instance: Enforce project restrictions on migration overrides
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/57c415871256445efa758086e6ef8111464b1c26.patch?full_index=1";
      hash = "sha256-3UJZzY0SgTUJwjeYUFDjzxL/xU5TeYY4ky649BGqy/w=";
    })
    # incusd: Expand network address set project for authorization
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/f86f08bfcd36aae7e8f29e83e71e6767ddb3e077.patch?full_index=1";
      hash = "sha256-epqnu2AayZsn/9im7VQJcCfoShRL3/BcUNXIDjJI9kk=";
    })
    # incusd/instance: Fix NVIDIA require.cuda and require.driver handling
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/038fd13e82c107ed40cad7697eabe45f3395a0cf.patch?full_index=1";
      hash = "sha256-OrArP0PJbBnGd0qVjlTxADTtdhWGLueJqM0Jt1J+1UI=";
    })
    # incusd/instance: Confine exec-output access to its directory
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/1e09276c318107c21091b9811643ef13e8692824.patch?full_index=1";
      hash = "sha256-5Y/fVAQBwVkOGclVIeYAF2+OJGeJsaldkBIkzqhz6eM=";
    })
    # incusd: Fail closed on unknown authorization project expansion
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/8cdc50343707525e01178b04f11350340b67eaa1.patch?full_index=1";
      hash = "sha256-VGODoJ/cPO+icGUMTgsmaSdudzPHShQDq2Lmp9Hndv0=";
    })
    # incusd/instance/qemu: Use os.Root for template output
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/a89084e2de1548513d349c5305f509ed80d43240.patch?full_index=1";
      hash = "sha256-+zcaHORD+DK9r8dsqTxSm8Khjr/hQBPw9st3K2qD/XA=";
    })
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/zabbly/incus/8834ea357ab4f0fd546077fa7630bd75762a485d/patches/incus-0001-incusd-instance-Confine-OCI-network-writes-to-instan.patch?full_index=1";
      hash = "sha256-/2kY2Us4hV7PemwgBzluF29MHEtM+dITDKsPb+/B3KE=";
    })
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/zabbly/incus/8834ea357ab4f0fd546077fa7630bd75762a485d/patches/incus-0002-incusd-project-Enforce-isolated-restriction-when-idm.patch?full_index=1";
      hash = "sha256-KIrSDgD4AI5F72YySAlPosBEQTZEfSQmkrSn3VUVtLs=";
    })
    # incusd/images: Check access before reusing cross-project image
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/83682ab16af5777b2a5650bb7c9878d57d0187f9.patch?full_index=1";
      hash = "sha256-Tz7e1/kHF5uhuTWJWeV74trhTkx8hLjfKuOCM1hpmXo=";
    })
    # client/images: Prevent path traversal in downloaded image name
    (fetchpatch2 {
      url = "https://github.com/lxc/incus/commit/9e188e31e43c21fa8f2a4cac265aa246d4c947f2.patch?full_index=1";
      hash = "sha256-KFYKB9PJK/U4/jSe3rmMeR9FWevvvi47BRy055Zj8Io=";
    })

  ];
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(7\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
