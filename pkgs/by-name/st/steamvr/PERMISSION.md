From: John, Gavin N. (Gavin) <gjohn@caltech.edu>
To: vrlicensing@valvesoftware.com
Subject: Permission to package SteamVR


Hi Valve VR folks,

I'm Gavin, an incoming freshman at Caltech. In my free time, I like to package programs for [nixpkgs](https://github.com/NixOS/nixpkgs), the package repository for the [nix](https://nixos.org/) package manager and its NixOS linux distribution.

I initially planned to package it by downloading it using depotdownloader, but discovered that SteamVR can't be downloaded in its entirety using anonymous accounts. This led me to discover the [SteamVR licensing page](https://partner.steamgames.com/doc/features/steamvr/enterprise), which had this email address.

Would you be okay with me modifying and distributing my copy of SteamVR for the purpose of making it available to install through nixpkgs? Nixpkgs has a mechanism to keep track of licenses that users have agreed to, so installation of SteamVR can require agreement to the Steam Subscriber Agreement, the Steam PC Café Agreement, and/or the SteamVR Commercial Installation License.

Thank you for your consideration!

Sincerely,

Gavin John

---

From: Ben Jackson <benj@valvesoftware.com>
To: John, Gavin N. (Gavin) <gjohn@caltech.edu>
Subject: Re: Permission to package SteamVR


  *   I initially planned to package it by downloading it using depotdownloader, but discovered that SteamVR can't be downloaded in its entirety using anonymous accounts.

Thanks for bringing this to our attention. I have fixed that issue.

  *   Would you be okay with me modifying and distributing my copy of SteamVR for the purpose of making it available to install through nixpkgs?

We would rather avoid that. I assume if depotdownloader works again, this would no longer be preferably anyway.

--Ben

---

From: John, Gavin N. (Gavin) <gjohn@caltech.edu>
To: Ben Jackson <benj@valvesoftware.com>
Subject: [External Mail] Re: Permission to package SteamVR


Hi Ben,

Thank you for your response! Thanks for fixing the issue with depot downloader. That's going to help a lot.

Some modifications to SteamVR will be necessary to make all functionality work with NixOS. Do I have permission to make a configuration file and script that makes the necessary modifications, and to have the config file and script distributed?

Thank you!

Sincerely,

Gavin

---

From: Ben Jackson <benj@valvesoftware.com>
To: "'John, Gavin N. (Gavin)'" <gjohn@caltech.edu>
Subject: RE: Permission to package SteamVR

It's fine to distribute patches that apply after downloading the base content.

If there are specific issues that you think are generic issues regarding portability you can also send them my way.
