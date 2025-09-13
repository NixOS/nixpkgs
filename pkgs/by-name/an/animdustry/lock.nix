{ writeText }:
writeText "lock.json" ''
  {
    "depends": [
      {
        "method": "fetchzip",
        "path": "/nix/store/3qxib3f1pglhdymz3kbc4dg361vlfz3a-source",
        "rev": "f4cc097ca9694f17feced9f82994f583ef7911fe",
        "sha256": "041cshfzgb4fb1xhamyhrx22dvib74d86y7qnbp6rm1n56mkqpkq",
        "url": "https://github.com/jangko/msgpack4nim/archive/f4cc097ca9694f17feced9f82994f583ef7911fe.tar.gz",
        "ref": "v0.4.4",
        "packages": [
          "msgpack4nim"
        ],
        "srcDir": "src"
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/fahrda7s5h7nw5nla0rhlm14vnz3nl7k-source",
        "rev": "987eb0d2270e998f9db317840e3f3608527274ee",
        "sha256": "0ihx7y0yny7ziq56mczzhkyjvkpgr4rbzfw7qqn2kizahv0y7wv3",
        "srcDir": "src",
        "url": "https://github.com/Endermanbugzjfc/bumpy/archive/987eb0d2270e998f9db317840e3f3608527274ee.tar.gz",
        "subDir": "",
        "packages": [
          "bumpy"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/8yhjzi799183f471wfjrbfcinwhfg940-source",
        "rev": "640f26142f47fea023a87bfd684a3fa770a785ae",
        "sha256": "03wp5vm92rjmn8igjkvsjjpkvsvh26ls7px3j7h8lclsxnj4flza",
        "srcDir": "src",
        "url": "https://github.com/treeform/chroma/archive/640f26142f47fea023a87bfd684a3fa770a785ae.tar.gz",
        "subDir": "",
        "packages": [
          "chroma"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/wc0x3n0r9pm5yzpyqdqnmjigd9v8gh1k-source",
        "rev": "b962cf8bc0be847cbc1b4f77952775de765e9689",
        "sha256": "0g7ilsplpjpbk3yl1sjnfkic1sj56zma22r1pl6qg4g70qq5h77g",
        "srcDir": "",
        "url": "https://github.com/c-blake/cligen/archive/b962cf8bc0be847cbc1b4f77952775de765e9689.tar.gz",
        "subDir": "",
        "packages": [
          "cligen"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/0nj37jsv6fcm4pvp15inl5212lhsnqji-source",
        "rev": "c87340c9a09fffc794f588c4a19b53c8d71cd6f6",
        "sha256": "0wc1skj1j0b4wy5lw0dj7fslfb6q14j3ngyh17v030w9gdy1pbsc",
        "srcDir": "src",
        "url": "https://github.com/treeform/flatty/archive/c87340c9a09fffc794f588c4a19b53c8d71cd6f6.tar.gz",
        "subDir": "",
        "packages": [
          "flatty"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/lzhf46islyz8h33f149nnbvpg9lawrxd-source",
        "rev": "be73f6862533c4cccedfac512d7766c8a30f3122",
        "sha256": "1y95n55hnjdpzjz6hx45nqp3i08aqq5qbjd641j168dv6qipqk3d",
        "srcDir": "src",
        "url": "https://github.com/Anuken/glfm/archive/be73f6862533c4cccedfac512d7766c8a30f3122.tar.gz",
        "subDir": "",
        "packages": [
          "glfm"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/yw2i5p4sz20z6jxhp1x4ii5h2kphai33-source",
        "rev": "79e0bb05eb552a7aec229d3ab8a653f11e32d44a",
        "sha256": "0sicr517nlzn1b6vm5bzak2sak89pfw60jyq6w9a69s055zvb7lj",
        "srcDir": "src",
        "url": "https://github.com/guzba/nimsimd/archive/79e0bb05eb552a7aec229d3ab8a653f11e32d44a.tar.gz",
        "subDir": "",
        "packages": [
          "nimsimd"
        ]
      },
      {
        "method": "git",
        "path": "/nix/store/6ndsxzh74l47xcxv4658plingybwywx3-nimsoloud-c74878d",
        "rev": "c74878dcb60fd2e2af84f894a8a8ffe901aecd51",
        "sha256": "08lzvggv4sa61kk1r5bhk22gfn20mqfi3yvmi55dyfwx6d7kvhp7",
        "srcDir": "src",
        "url": "https://github.com/Anuken/nimsoloud",
        "subDir": "",
        "fetchSubmodules": true,
        "leaveDotGit": false,
        "packages": [
          "nimsoloud"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/71nk2pf5711fpbkjni78r02m495lfgra-source",
        "rev": "2a7d897fa0b021523ea76f6b794a12e6a7c02c5c",
        "sha256": "1n3ggl9h7vpgdl1fz8g66ymsv1rrnlzd8j27xf8nal82k8jfvvpl",
        "srcDir": "src",
        "url": "https://github.com/Endermanbugzjfc/pixie/archive/2a7d897fa0b021523ea76f6b794a12e6a7c02c5c.tar.gz",
        "subDir": "",
        "packages": [
          "pixie"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/rsl57icycln5b3087s5qzl23a83b4gyv-source",
        "rev": "57e64daacb23890cf9851c57d6d90608fbb4ca98",
        "sha256": "1pw0lk2wfyyssbv1qr756s48884xg5m25f0fic07anzaxs80z570",
        "srcDir": "src",
        "url": "https://github.com/rlipsc/polymorph/archive/57e64daacb23890cf9851c57d6d90608fbb4ca98.tar.gz",
        "subDir": "",
        "packages": [
          "polymorph"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/ibfsmhmx9zgfb4dvzix2a7bmk7kvdl40-source",
        "rev": "35ec546322abe76b69c53baeb4d2a5f3f762ea08",
        "sha256": "044slvx78c14rmp7cqdh7sasir1043avqmkpcc0ir8h6ml668c66",
        "srcDir": "src",
        "url": "https://github.com/Anuken/staticglfw/archive/35ec546322abe76b69c53baeb4d2a5f3f762ea08.tar.gz",
        "subDir": "",
        "packages": [
          "staticglfw"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/7dly89kba9s2ik8cxiicsxzc3jqnlz2h-source",
        "rev": "ba5f45286bfa9bed93d8d6b941949cd6218ec888",
        "sha256": "13csi17rpaclvm7ji3rw1hcbb1z6x5270819nabinfw1x59al5yz",
        "srcDir": "",
        "url": "https://github.com/define-private-public/stb_image-Nim/archive/ba5f45286bfa9bed93d8d6b941949cd6218ec888.tar.gz",
        "subDir": "",
        "packages": [
          "stb_image"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/v0pqf0c4db80ymj0xwivgi806ymw9qra-source",
        "rev": "1110b97fac745feb458aa44164e8456e2777c16d",
        "sha256": "040mcxnmcm44rhnxpn56q653np3app3mgrzqfv2k8510awmr309n",
        "srcDir": "src",
        "url": "https://github.com/treeform/vmath/archive/1110b97fac745feb458aa44164e8456e2777c16d.tar.gz",
        "subDir": "",
        "packages": [
          "vmath"
        ]
      },
      {
        "method": "fetchzip",
        "path": "/nix/store/6p3kcgnzq4byzk6p01538cxkx9rkh7ks-source",
        "rev": "1112c71b4e215c1b52b607dec786af27ba55ce9f",
        "sha256": "1fvxvjmq09lp3pqr0l7rivv9pwiksv4v9dj5jr66r15crjpm72i9",
        "srcDir": "src",
        "url": "https://github.com/guzba/zippy/archive/1112c71b4e215c1b52b607dec786af27ba55ce9f.tar.gz",
        "subDir": "",
        "packages": [
          "zippy"
        ]
      }
    ]
  }
''
