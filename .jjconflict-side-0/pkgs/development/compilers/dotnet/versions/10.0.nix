{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.0-preview.3.25172.1";
      hash = "sha512-6EPWvSe4P2RIaPFsMNaV2DVt70aNK5TdaY01yvfpcYPymFbjDUu1UkP/fvYffqbHWz9F8jA1e12Gf6k4ZFZfzg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.0-preview.3.25171.5";
      hash = "sha512-djHPueIEWs51lpwMRjyRH+ivN9Ry+W4safVUoAK+i/nws4rw8qcS4yOXyTNb3Gsp7z1zhmaz4VLtPi0mAqDiJw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.0-preview.3.25171.5";
      hash = "sha512-a9kvdDbqV2s8EBvgiPNsv9QaNjNVK2ObIbNhpGoctJrUKYsug3oGNfZGg54UXFa1YGjxXZiwU094krCsKztV2w==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.0-preview.3.25171.5";
      hash = "sha512-mn/z63bmzyZ4TUzscNa3eAHAfYyP7IL/DKKxdxwlJOUMqepNAtH1XTtYxGU1VHyD8neetVDxn6Gbq68m5V5JKg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.0-preview.3.25171.5";
      hash = "sha512-qM2slv5GBVeXmMtifdJjY3CDikHlFGRIcJshWBWnCe9Woo8fLhDL0m9JcyB89Vjadxg+zyX/QwW8WlksLTC/zQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-8NFv8CsWFmlq+p09oD7HLZIOJxhPD5k78B1GByieHPOP6Vb0DOwgXaGEDRDUsLda10Ja6neKLMcePDJHi+Olvg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-wZnQnwgHJllGa3wEkDm/oCvPw8eAp0Ws68MSHBPk8hfB4AokKZhpKkvpjF/um+R9CB5hUBjTqeWCeDPgttJn1g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-oReXoopFpm4oEl5JTYuMQ5gXP8bSWvmkrysNT50E0tq+BdNeyYVsgOlobSbT5qTce9oGq2aNauZ0Tt51dAeObQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-3phc9t1V1ozdw6LQEOS7EmqcP899cCfO+M2kfrX+nYylZDiEGqjwom5UDtk5hiLKnqWYDeD1PtukuiC4zjvGNg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-IP+gfV9BIcepxBtShwNvtYRs7+50o9mRzL3V5pU/v2WJawt+qTfZhbyoDPm7mY+SqEZd9GP2pcSWaelkEeJgmg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-kU8OWd7q9x6mYUqpzGQEydfmSPy3h/33fT2fv43gdw8k3B3wJSAKzHacxiUvPOMhcI8yk9vV0mpMp2g2RgKQ9w==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-SQDs6SBNVrCGv2X5u2PXoXFGsrPCS2sCE/Mmk+7/nz+9v91eNZEwyz94tFgb+poWXG4QQT2cohN2CpRo2s6dJw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-kDv0dDw6mIeNOiOl4jfS6VkiSJEnsyMtWPtqml7gko9we1tsjL6nA3Mw9hwXNQCG1nyxHZRvqIugb6+AzrvjEg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-QK8WDohhna92ZYdEGo8hRYFXnMxEdFpO8dbwwPJH0qkf0nNgs001O0WlHKy8IOT7RN5kyecsRg2WqIltAGnTmg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-n2oC8z01tjlsC7CUOiM96nzh8NqjP4EgF0vlFzZnecYumFt0iaufXAHUT+PZWaKNgZdnDPkeCToTL1cV8tIcMg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-T4loVTfIPvtn+Of6I7ZkhNFOXwPMLPSC/sYHeYX4jgYVtD12+FNRTR1oli7FEMoqlLo1QKdgETSR5KnB1k2Gng==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-qe6ujRvuq5EIL5zJqHb4f17iCQZZsY/EgmeqlI5sYqKzbetYL2l1OO0Brvo1FvbGZrtMBymDwFBrE+EvvgmQkA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-bVbI7yECpoFjelziPtW4fHs2Pfenqlx/4DtnEAXBcg/MUcREqWMjfzm0Zyjk+gJxst+QYcbhJCBWeOyc7678Lg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-Po6jpksZOBmAickXw/0JZ7jecfSVE5vwDDFB19I9rO3jUJDKVGr032bDqKTGYvdR665W5Dy6/koXyVlTuL+8mQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-uijNe6tay3LpewWLXwA8VMkZk6uKluqyP9jomkOto1MkiP7vRavYLSLDTXVAQVpLaQdof/BtLotF92D757MNrA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-ZmIjeR1dW5FwgcwqY4Q2BZJ6/YKwQOFsVXSKGyBv/qpesnYqlnRNvxVeoPL02cZw8zZmFHzCLlZwxdU8lKXnzQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-5qpGqGii1NTkNntRliC+tU6LuvfB2uX02c48o3zQKP9D9ttQs8IZWSMUMxq/1dGGsXNKhhRunSrUA2vxUarzVw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-HyedU9hYd6vbzAJHHCqiAnW/KSliXqPpuTAvfC1B3A9M9PLDHjD5eOyGzdYie0Jy6ZWMaRmi57F83l3P1Uz5IA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-DHFeg1t4ziSI9U+EMmEiQqaqq3Xc7/vLIBvKOM3XFc8rTcW9/vKfSvEuf18YVg/FQ1c4gzymc2x4A9gyBzlC4w==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-6T9Ef8ICSc8Pe1Nor/2HZenyNtWmh/lUrFCJrLcGeMe48w34N+pkWqB7Cvhr8Ohm0jp3zmNLVefFai3kHcwALg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-DLV2jcQ7u6s5iMvL4tY8js9P9e/cP4IjUEyQIhewmZHPrYe/enBjsuxJJuLhKgkj0UP6xdqiCRgCzwpKPl8Mmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-vmtV/x6dJrFEkDMSMPC8eXCrfkIA552v42MVdxHKsUpTbNY9abPf2wmdYd4dB6pe5UEY8hRet63q9PuZGKdYXQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-n1QZ7D1g87ZeTGun/wnKkaKGaRMiPZzQvD1e6D8ND+0+MRH77oG1bsDUxQ1SGcV2AnwfwJKaeAzs74waPsaORw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-jj3WBhN+ICfMFHg6/28dCbfUYe19b/lRr6Bde+T10tu6JRvKj3TPZEeHyNKLSMQuw32LgIwvNTUpRNGiKkL3Ew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-KA1ElJEvOCF5HmdHimY5Byl2pU01qPlCKlxTn75QhviFhJLsyhqmgBQAOM/bs+p31I1AiPGU4WLHOhjrijsoXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-M+jygZyqjn4rcODKaIcmMl25HQuiale3p+QDNF+VZF52+8+jS5BNQqAACsmKAum+1kclPT8IVw0Q5rWiqeZ/BA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-CBDipTRnvOx4H35VTCYPKnKl13dMzXI8Hi9+88qmBu6y85zRBGRM8vOYLCPTYO9x4AumdYjl0LfR8GCeUvSUKA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-iOuaoiZ2j0lhha2wVMRS/QDyBXesT/LCO9mXxDCzym0vo/Cqv4NlVoO5DtgLD0P6CF2OEQDHumc5RCN4vJ10aA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-iZbG6u6pPUJYK+IM+j0PLqd/2B+CeL9uAEW6AhoZkV6Km2l2vGy7FzHGDTfiJ71DMcEC2GXwV3wFHEp2QhRPhg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-quvX88oZgt9jwaddac1+YbytUK5fu+JXzbl73Cyxlc0u/FYsXwpb6tA581RQvtuVkw6LE+lUE9dNKKYHhYVK3w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-b8F+rf2x99OJOXwFcgGlnj3JmyC3Xsa1SfMCMwQVPXwsxCsYD3jHvuNVrGfkDPW8deQw0SYMOCIpHa/gxPwtmQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-EcqDkf4DJgFcoukaVZBOmlHPq9J5tmmYdpiib42+zMdh1GGhGGFBSVVF63/kkGaUOwRSqCgPHjFiWQGmEnwcsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-v0cONvJMRN8YYh/JirrOkj5ephdzM5CYkHQbg4RP84ulxQDX4ohdZfpq5N3b0TaIKbBmPXdKVce72iO0A7SnSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-pEdDDcBOa6/FxnyA8q0Mwy7uwEa8FWx3gnvXga7AXLbMNxkqlg9yWductV7worLKyKCC9Uj3qPBizvL1eI36IQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-QUWIswNWhC3J5MWD79kfPLWRqk+tNyOIsgAHiM8Jg3BTGb53F0EUXxov4RZXA6AkJpIpmJwg/ifRQsvRrQg2Bw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-ttOCcCfYwjexaKlyTzxBP/8qy3F4kmvkuox0/jwYUcHDtrVrVlEfNQfASyHkuDly1xu81IbXOxZ2iHzPYGNfEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-0HO9RPE8i4IMhAl2NZ9rrxTeDdAXCwaJZibWxbrTKv5GqraDKfp+RW5VSBRP0O+72NzQ7eoXN68ffTFnTRLXHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-TK5qDNxh0ETr19gy/A1IptPF38aGc1kLNIiI+aHHi8ylY9gFNkoQUSioTMJVldFLdqRpykglNjcf7pddvwEO5Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-5zq99vRkEii3LBXre2ikH3aeyjKFIaYp+czLvKmDRCshqKhhMpATeaRhC2d9CF3gfPJy2MiPcooLDHkUoTLq7w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-sZiG96cqPlzdraL/dc5rCvilc0yICwDEyiFJUe1bLh9jJq60flbc7E8XWZBWOX6FlNmKBjTY3VNvBvliqxbxHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-ZWKdyUbmetB+f29zwosCf3tx5Fn+26b07MPWfyr23Z4ZeKOlGjRs0sF33cbXvFnPiptauED1nIYcF/3yxvgPNg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-mdvXhNvndpv/HJTWb5i/ett10AU3G2uf+H5EUuYanidUZPLjCAuaZrdpphRQ3A5n7mSqmFjV2SVj+5Cx+r4tgw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-2KEqtFKXBlvthsGtzwwG/xBkbSrjk/X5/szu+yOA/8C9QXGDaXX105QoKvYXLs7l4cI8q1W/AJsbY+RtDhN+3g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-jH4jcE0ChOIz9p6YyYsyBm2vYMNVnnpVb9jxO0y1lCDZq0PhR1e7xfVXTDNt3nS9DKcZwkpcMxVtsyuGuyDzhg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-lbWSZVMC6nZZgikEiySBhZ8ZyP5YozGm6t8bgXRAplqzj8u6gzW3fWw3DOBublXYF9MPZ05MzWaypsINWV7Xig==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-hCWVIgttD0s6khSBNvB0gFn260Kc4WkgApk/zqC4ziOIRCms+aOpBxBO+xMhyRqmRZWsZJ9Ohq7ggusm344X5A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-qo9klsb9z4APoU953tdmweeYVFaNpWoHiuthCSxUMiVu6EdoyA+FJdAtBtVi6gPKVBn6XXpXoIgGci3LqNpu5Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-N94WrvCxYTJc8Klas1LxLVbKmUHFGor+vkjVvCeyssWEFRhdWY4OyqZnFZ/mFJrSsITBOPh2iAqIG5ShYLt77w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-LR5c8V89MIOh3rUXU0gBsxkq/WlU6F+NqJg0TfiyETIv1ydRCeFXfCQV4lXwadN8qTwn4zd+PzjwHwHA1/W81Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-7NdGgo+SWrF/mZ2wm3C40e/lQisYkwLZLOCITcU0mcW6ibDBOTd/OTeqDkes1x36cY4Fm/Y06zDOk82u9jdRkg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-A8p9AlzeE8kwZtPeMLcd7a/IVksuCHwcwfCcPB+W4TVNWS1uBs+E52GC+xlGX3vCIr/bK2JxHDeK06vdQtsOEw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-8fftAVEzz3i6moABJtjYgoGqmaJpZGB8BUsV+Nj35cva6pZMNKj5qfE/xd/bSk8NLkSeMIgiIpeVQI1nliR/WA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-QDfByMHTTXC3aEEWa9/7pCFL2QFZ2E2ybj/Ta36QGj/X5un9Ng5Ztaj86wu0UfroOmvhDwd6Ygr9gId7P0lIMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-MtejXHgozKgiPWriUIwC9FqB/Xnok5NateB3kQtTFXi+Pvrrm11lSQc4kGZxzYygOyR7s2g6z37DVhGRDymsQg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-cU80OUIPhSTNp9tf6YSvZ3QEZn+XC7+YupDbvwaSJH9yK0K2lhk+0dQ9uisprRdMAew8Mta+/E6tLHbN23KGYQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-pk4aum6iyjgTur17QfXaRhriAwXTIOVCQm1LHMPDv1MitPXOun1SlQcVk+Av9Kg6cayt2rRg+yOcB066cuxANQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-akzO73LBCnrKU10ch+n9EKeYzRgKud/Amf6gBu0tkO/6FtEnaDUy0AfKXi21+W1nkQMQfjgXxSEzv1FwFw7eqQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-ocbdommNfRdK2iK229mm+FzRCnrzCs6Y9cIp2P50KpZ86PSxqA5VkBdPkiCVeWA8q20ld/t4Y6WAHecFdmK1Qw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-SQSwMCRj02knABJECNoppoFClJWRYHi0oKCx6dQYi6+3xMO9T5BCW5/JIcWz4bN1jTXtp3JrygDrQQbDxe04Cw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.0-preview.3.25172.1";
        hash = "sha512-4PHy2l3Zl3hMRV5T8cs5ZTBP54jSDiEtOVt6Eeezy6dAFZ8nm6QmKAa+0o7/atfuhB4+NagQNGe+geVOfO0E1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-lvJa2HYOMIUDIFdXNOOBLT5+8GJv+sbkSULxwr7bDu7NEzprtln59YJLvlEsF5WnEkoPInQ8rvxwI2Ae674QQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-P4DNGDx+k6+D2blK3qTaPkBx1Mqh8+ugyVhe2N6HRBUME7+TxA+HBQQxThSnPIWiE0gddhsL2cN71SWl/KA+9w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.0-preview.3.25171.5";
        hash = "sha512-jd7rET8GG4SUdTgG3TtJvzEhVk77LsszcUMO9IXtPWdXkM97ITFLOV+C4JsrIRjkDIICdNoUXmTK6qokkiSP6Q==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.0-preview.3";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.0-preview.3.25172.1";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-linux-arm.tar.gz";
        hash = "sha512-+cOkZVkkYE5OTtQ2UzPQlEKsETXKGV4PgjdJmRWfTmfQs+8H7bYNh6TS8d+i4LHfTkn8efndJIZ3rqnbYj2RRA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-linux-arm64.tar.gz";
        hash = "sha512-SFaKqKP9QxpndckPJnVBNsh7id6p4HswQQG9jG3Elh8UNvpaAxb36VNRmKl4Y2yvdCX5t6rgA7U6laHhSgG0UA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-linux-x64.tar.gz";
        hash = "sha512-WS548j0O7sP+IdOIXWtLLOZVOOaph9nUCU3VrPyYNR6qhEGEXVO8DNwdSfO0weapOg3azUS9XH9QoB7q52JH9A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-linux-musl-arm.tar.gz";
        hash = "sha512-8bBuZRWQuoZtwxLaCKhbSz5MjXGh3OnVcZ4ehvXXrWRpE96tlVLXTu7dfLcKNJ0Q/VTHfbya0Js0Mn9zn8RQkg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-linux-musl-arm64.tar.gz";
        hash = "sha512-jezw7PXasMHQmDLDQZwIy2ugJ/wXE/CheremG4k2mGfa+rrxcENA4NuBdTtlqmPhMbdZaf59fuWOAciFTGy6aw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-linux-musl-x64.tar.gz";
        hash = "sha512-b8ZDLNoDdFRI5BUsBtc3vYv6Q1bis4oLSGGfK2/3X/HR9m9yRJxkMiTKfwTFBe/hrzXg5m3TEeXt+zSsZZnljQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-osx-arm64.tar.gz";
        hash = "sha512-I/6af+Ym7p8KzfZIQvu2vN+B1rTvlwN7wS3jzfamrn/dIYNzSHzhhbg/ua9RRhiLE2jV7ugr31mwiZCMewMq0g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.0-preview.3.25172.1/aspnetcore-runtime-10.0.0-preview.3.25172.1-osx-x64.tar.gz";
        hash = "sha512-ylaA7IOt1T3ZwmHTtKmqOiNToWiImv9iFjAOp2t2C9QkYFiiuij1YqqCIwL0xSLHxbSxSZ4T6xhR2d0VZvOXew==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.0-preview.3.25171.5";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-linux-arm.tar.gz";
        hash = "sha512-jmkCWUVKVAwMFiWL7WWcCiZkDSpPS6fhlOKAfkWX4mdWT8DJt4koBaT6jgECGd49IimhAm4IGJ8PHsoFmjqe5g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-linux-arm64.tar.gz";
        hash = "sha512-pqWUMsEqwZZJV8oJ944V4LLWQ12bcLoTtrwj7JnJUj6B4jKX/igpf6cjyv9KXSFZoMq1BHDeYj6BciRdQ0Px9g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-linux-x64.tar.gz";
        hash = "sha512-TpvSvdVBJMld1ivPlqX+6glWF9c/Eyz8yDMtFamoNmwDv+VdAudAnqjuPTXaHrDpg5C57D/IbpKMZwbFNf5n+g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-linux-musl-arm.tar.gz";
        hash = "sha512-l4iVp2OfDBsIYOs8KTImVT5OrupbpwOapd8OtXKEZXoiVeYBxlpA4l1SSDg4hLBc1AHTRyz2CTSmVyYAfMHeSg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-linux-musl-arm64.tar.gz";
        hash = "sha512-dTKrTRaK18qG/cpG2z+UR7ns6GaI/cAR1Fl+Smiu2qSzrwB5wvkvSrKlRuerbs9SXcae9MEdAyyEwpc4x6Yq2g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-linux-musl-x64.tar.gz";
        hash = "sha512-JpFKYBQ/o5TR8jjU2jNa5YaWlombMdqbH1N9+W4vSxhizasR6i5VDa6aGYF+42eaqg5NuWVs6+UUO4UTCQ3+5w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-osx-arm64.tar.gz";
        hash = "sha512-zAL9I0wBLIY9hyXYi20wKyFPuY0BcVcpFapt/jJIgTQPd7ccyBtT/AYtKJNnW7OZdxuuBd0tEPVEqi+p1pHkQQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.0-preview.3.25171.5/dotnet-runtime-10.0.0-preview.3.25171.5-osx-x64.tar.gz";
        hash = "sha512-ip6Xu1Ubo6JJMEPbbVX6opwHVtj14aiWBheUHQGUGo6zKXvaOuAWXFhlacUfKt2gHVAJVZkA9Qy9S55Z7u2jJw==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.100-preview.3.25201.16";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-linux-arm.tar.gz";
        hash = "sha512-lAnYqQa64mGyLycsyAobQbi+dyZDdwiBWUTiMjlvD4ibh03zezwo5hWAAtKuV482yAjXZwYiqfXLkkLfZv/8XA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-linux-arm64.tar.gz";
        hash = "sha512-nh993ZjUaPk3t0RpOXsfwSOMQXS5TcWnjmHGmENZ9ZTc/QwkjlAuvaFl7GEAGY67eXsdoIvkcyDOkmYSMYtl6g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-linux-x64.tar.gz";
        hash = "sha512-qq13jMgPXl8CPL2rR69ncDIUp6GQDRJ4L12Vb4Yj3hvTgBAmcn+7Xs+E+8iFGF2q2SgytH2jtlFKRapW+pcRVg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-linux-musl-arm.tar.gz";
        hash = "sha512-p6urvhvT1LhTQZn4cjV86y9fCn2h9L/5qSm6eZ+MjmsAGASFJOjHYM1KFdj5mXLpk7XnKFkmAgQKkF8GiE79RA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-linux-musl-arm64.tar.gz";
        hash = "sha512-kFfpcAb5nk//HMCmiEQ8Rpz8JXOarrdS2L5a6mtJTrSUGdlUM51YOA6J/LViikJPlnzcYRK40UNX3KB/nxYNXw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-linux-musl-x64.tar.gz";
        hash = "sha512-VEOi4J6szynQ3JIzCkiZFAYnp5AeedE9drnV0kmpYTdVKDEjbSFJMs08asVrxDf6vnsXMClmH7XQYQZKBuVnHg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-osx-arm64.tar.gz";
        hash = "sha512-s4pu98ZWjqXi/Wy9iTqOBd0Vjl8hpCRbObIr7gIxAzhpxsK/V2x2JgyfpjOh8O8diLPl6c0c+Hm16kXpqmYA3A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.100-preview.3.25201.16/dotnet-sdk-10.0.100-preview.3.25201.16-osx-x64.tar.gz";
        hash = "sha512-apxmNBdgJyUvvWzD3dEKXuseQCaPWKpyXsUOqU74c2K/sVT/HxJYR5Kx+VZxD/gHBCHZ+GpGONKzku8JkQpZRA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk_10_0 = sdk_10_0_1xx;
}
