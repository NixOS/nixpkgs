/* List of NixOS maintainers.
    ```nix
    handle = {
      # Required
      name = "Your name";
      email = "address@example.org";

      # Optional
      matrix = "@user:example.org";
      github = "GithubUsername";
      githubId = your-github-id;
      keys = [{
        fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333";
      }];
    };
    ```

    where

    - `handle` is the handle you are going to use in nixpkgs expressions,
    - `name` is your, preferably real, name,
    - `email` is your maintainer email address,
    - `matrix` is your Matrix user ID,
    - `github` is your GitHub handle (as it appears in the URL of your profile page, `https://github.com/<userhandle>`),
    - `githubId` is your GitHub user ID, which can be found at `https://api.github.com/users/<userhandle>`,
    - `keys` is a list of your PGP/GPG key fingerprints.

    `handle == github` is strongly preferred whenever `github` is an acceptable attribute name and is short and convenient.

    If `github` begins with a numeral, `handle` should be prefixed with an underscore.
    ```nix
    _1example = {
      github = "1example";
    };
    ```

    Add PGP/GPG keys only if you actually use them to sign commits and/or mail.

    To get the required PGP/GPG values for a key run
    ```shell
    gpg --fingerprint <email> | head -n 2
    ```

    !!! Note that PGP/GPG values stored here are for informational purposes only, don't use this file as a source of truth.

    More fields may be added in the future, however, in order to comply with GDPR this file should stay as minimal as possible.

    When editing this file:
     * keep the list alphabetically sorted
     * test the validity of the format with:
         nix-build lib/tests/maintainers.nix

    See `./scripts/check-maintainer-github-handles.sh` for an example on how to work with this data.
*/
{
  _0qq = {
    email = "0qqw0qqw@gmail.com";
    github = "0qq";
    githubId = 64707304;
    name = "Dmitry Kulikov";
  };
  _0x4A6F = {
    email = "mail-maintainer@0x4A6F.dev";
    matrix = "@0x4a6f:matrix.org";
    name = "Joachim Ernst";
    github = "0x4A6F";
    githubId = 9675338;
    keys = [{
      fingerprint = "F466 A548 AD3F C1F1 8C88  4576 8702 7528 B006 D66D";
    }];
  };
  _0xB10C = {
    email = "nixpkgs@b10c.me";
    name = "0xB10C";
    github = "0xb10c";
    githubId = 19157360;
  };
  _0xbe7a = {
    email = "nix@be7a.de";
    name = "Bela Stoyan";
    github = "0xbe7a";
    githubId = 6232980;
    keys = [{
      fingerprint = "2536 9E86 1AA5 9EB7 4C47  B138 6510 870A 77F4 9A99";
    }];
  };
  _0xC45 = {
    email = "jason@0xc45.com";
    name = "Jason Vigil";
    github = "0xC45";
    githubId = 56617252;
    matrix = "@oxc45:matrix.org";
  };
  _0xd61 = {
    email = "dgl@degit.co";
    name = "Daniel Glinka";
    github = "0xd61";
    githubId = 8351869;
  };
  _1000101 = {
    email = "b1000101@pm.me";
    github = "1000101";
    githubId = 791309;
    name = "Jan Hrnko";
  };
  _1000teslas = {
    name = "Kevin Tran";
    email = "47207223+1000teslas@users.noreply.github.com";
    github = "1000teslas";
    githubId = 47207223;
  };
  _2gn = {
    name = "Hiram Tanner";
    email = "101851090+2gn@users.noreply.github.com";
    github = "2gn";
    githubId = 101851090;
  };
  _3699n = {
    email = "nicholas@nvk.pm";
    github = "3699n";
    githubId = 7414843;
    name = "Nicholas von Klitzing";
  };
  _3JlOy-PYCCKUi = {
    name = "3JlOy-PYCCKUi";
    email = "3jl0y_pycckui@riseup.net";
    github = "3JlOy-PYCCKUi";
    githubId = 46464602;
  };
  _360ied = {
    name = "Brian Zhu";
    email = "therealbarryplayer@gmail.com";
    github = "360ied";
    githubId = 19516527;
  };
  _13r0ck = {
    name = "Brock Szuszczewicz";
    email = "bnr@tuta.io";
    github = "13r0ck";
    githubId = 58987761;
  };
  _3noch = {
    email = "eacameron@gmail.com";
    github = "3noch";
    githubId = 882455;
    name = "Elliot Cameron";
  };
  _414owen = {
    email = "owen@owen.cafe";
    github = "414owen";
    githubId = 1714287;
    name = "Owen Shepherd";
  };
  _4825764518 = {
    email = "4825764518@purelymail.com";
    matrix = "@kenzie:matrix.kenzi.dev";
    github = "4825764518";
    githubId = 100122841;
    name = "Kenzie";
    keys = [{
      fingerprint = "D292 365E 3C46 A5AA 75EE  B30B 78DB 7EDE 3540 794B";
    }];
  };
  _6AA4FD = {
    email = "f6442954@gmail.com";
    github = "6AA4FD";
    githubId = 12578560;
    name = "Quinn Bohner";
  };
  a1russell = {
    email = "adamlr6+pub@gmail.com";
    github = "a1russell";
    githubId = 241628;
    name = "Adam Russell";
  };
  aacebedo = {
    email = "alexandre@acebedo.fr";
    github = "aacebedo";
    githubId = 1217680;
    name = "Alexandre Acebedo";
  };
  aadibajpai = {
    email = "hello@aadibajpai.com";
    github = "aadibajpai";
    githubId = 27063113;
    name = "Aadi Bajpai";
  };
  aanderse = {
    email = "aaron@fosslib.net";
    matrix = "@aanderse:nixos.dev";
    github = "aanderse";
    githubId = 7755101;
    name = "Aaron Andersen";
  };
  aaqaishtyaq = {
    email = "aaqaishtyaq@gmail.com";
    github = "aaqaishtyaq";
    githubId = 22131756;
    name = "Aaqa Ishtyaq";
  };
  aaronjanse = {
    email = "aaron@ajanse.me";
    matrix = "@aaronjanse:matrix.org";
    github = "aaronjanse";
    githubId = 16829510;
    name = "Aaron Janse";
  };
  aaronjheng = {
    email = "wentworth@outlook.com";
    github = "aaronjheng";
    githubId = 806876;
    name = "Aaron Jheng";
  };
  aaronschif = {
    email = "aaronschif@gmail.com";
    github = "aaronschif";
    githubId = 2258953;
    name = "Aaron Schif";
  };
  aaschmid = {
    email = "service@aaschmid.de";
    github = "aaschmid";
    githubId = 567653;
    name = "Andreas Schmid";
  };
  abaldeau = {
    email = "andreas@baldeau.net";
    github = "baldo";
    githubId = 178750;
    name = "Andreas Baldeau";
  };
  abathur = {
    email = "travis.a.everett+nixpkgs@gmail.com";
    github = "abathur";
    githubId = 2548365;
    name = "Travis A. Everett";
  };
  abbe = {
    email = "ashish.is@lostca.se";
    matrix = "@abbe:badti.me";
    github = "wahjava";
    githubId = 2255192;
    name = "Ashish SHUKLA";
    keys = [{
      fingerprint = "F682 CDCC 39DC 0FEA E116  20B6 C746 CFA9 E74F A4B0";
    }];
  };
  abbradar = {
    email = "ab@fmap.me";
    github = "abbradar";
    githubId = 1174810;
    name = "Nikolay Amiantov";
  };
  abhi18av = {
    email = "abhi18av@gmail.com";
    github = "abhi18av";
    githubId = 12799326;
    name = "Abhinav Sharma";
  };
  abigailbuccaneer = {
    email = "abigailbuccaneer@gmail.com";
    github = "AbigailBuccaneer";
    githubId = 908758;
    name = "Abigail Bunyan";
  };
  aborsu = {
    email = "a.borsu@gmail.com";
    github = "aborsu";
    githubId = 5033617;
    name = "Augustin Borsu";
  };
  aboseley = {
    email = "adam.boseley@gmail.com";
    github = "aboseley";
    githubId = 13504599;
    name = "Adam Boseley";
  };
  abuibrahim = {
    email = "ruslan@babayev.com";
    github = "abuibrahim";
    githubId = 2321000;
    name = "Ruslan Babayev";
  };
  acairncross = {
    email = "acairncross@gmail.com";
    github = "acairncross";
    githubId = 1517066;
    name = "Aiken Cairncross";
  };
  aciceri = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";
    github = "aciceri";
    githubId = 2318843;
  };
  acowley = {
    email = "acowley@gmail.com";
    github = "acowley";
    githubId = 124545;
    name = "Anthony Cowley";
  };
  adamcstephens = {
    email = "happy.plan4249@valkor.net";
    matrix = "@adam:valkor.net";
    github = "adamcstephens";
    githubId = 2071575;
    name = "Adam C. Stephens";
  };
  adamlwgriffiths = {
    email = "adam.lw.griffiths@gmail.com";
    github = "adamlwgriffiths";
    githubId = 1239156;
    name = "Adam Griffiths";
  };
  adamt = {
    email = "mail@adamtulinius.dk";
    github = "adamtulinius";
    githubId = 749381;
    name = "Adam Tulinius";
  };
  adelbertc = {
    email = "adelbertc@gmail.com";
    github = "adelbertc";
    githubId = 1332980;
    name = "Adelbert Chang";
  };
  adev = {
    email = "adev@adev.name";
    github = "adevress";
    githubId = 1773511;
    name = "Adrien Devresse";
  };
  addict3d = {
    email = "nickbathum@gmail.com";
    matrix = "@nbathum:matrix.org";
    github = "addict3d";
    githubId = 49227;
    name = "Nick Bathum";
  };
  adisbladis = {
    email = "adisbladis@gmail.com";
    matrix = "@adis:blad.is";
    github = "adisbladis";
    githubId = 63286;
    name = "Adam Hose";
  };
  Adjective-Object = {
    email = "mhuan13@gmail.com";
    github = "Adjective-Object";
    githubId = 1174858;
    name = "Maxwell Huang-Hobbs";
  };
  adjacentresearch = {
    email = "nate@adjacentresearch.xyz";
    github = "0xperp";
    githubId = 96147421;
    name = "0xperp";
  };
  adnelson = {
    email = "ithinkican@gmail.com";
    github = "adnelson";
    githubId = 5091511;
    name = "Allen Nelson";
  };
  adolfogc = {
    email = "adolfo.garcia.cr@gmail.com";
    github = "adolfogc";
    githubId = 1250775;
    name = "Adolfo E. García Castro";
  };
  AdsonCicilioti = {
    name = "Adson Cicilioti";
    email = "adson.cicilioti@live.com";
    github = "AdsonCicilioti";
    githubId = 6278398;
  };
  adsr = {
    email = "as@php.net";
    github = "adsr";
    githubId = 315003;
    name = "Adam Saponara";
  };
  aerialx = {
    email = "aaron+nixos@aaronlindsay.com";
    github = "AerialX";
    githubId = 117295;
    name = "Aaron Lindsay";
  };
  aespinosa = {
    email = "allan.espinosa@outlook.com";
    github = "aespinosa";
    githubId = 58771;
    name = "Allan Espinosa";
  };
  aethelz = {
    email = "aethelz@protonmail.com";
    github = "eugenezastrogin";
    githubId = 10677343;
    name = "Eugene";
  };
  afh = {
    email = "surryhill+nix@gmail.com";
    github = "afh";
    githubId = 16507;
    name = "Alexis Hildebrandt";
  };
  aflatter = {
    email = "flatter@fastmail.fm";
    github = "aflatter";
    githubId = 168;
    name = "Alexander Flatter";
  };
  afldcr = {
    email = "alex@fldcr.com";
    github = "afldcr";
    githubId = 335271;
    name = "James Alexander Feldman-Crough";
  };
  afontain = {
    email = "antoine.fontaine@epfl.ch";
    github = "necessarily-equal";
    githubId = 59283660;
    name = "Antoine Fontaine";
  };
  aforemny = {
    email = "aforemny@posteo.de";
    github = "aforemny";
    githubId = 610962;
    name = "Alexander Foremny";
  };
  afranchuk = {
    email = "alex.franchuk@gmail.com";
    github = "afranchuk";
    githubId = 4296804;
    name = "Alex Franchuk";
  };
  agbrooks = {
    email = "andrewgrantbrooks@gmail.com";
    github = "agbrooks";
    githubId = 19290901;
    name = "Andrew Brooks";
  };
  aherrmann = {
    email = "andreash87@gmx.ch";
    github = "aherrmann";
    githubId = 732652;
    name = "Andreas Herrmann";
  };
  ahrzb = {
    email = "ahrzb5@gmail.com";
    github = "ahrzb";
    githubId = 5220438;
    name = "AmirHossein Roozbahani";
  };
  ahuzik = {
    email = "ah1990au@gmail.com";
    github = "alesya-h";
    githubId = 209175;
    name = "Alesya Huzik";
  };
  aidalgol = {
    email = "aidalgol+nixpkgs@fastmail.net";
    github = "aidalgol";
    githubId = 2313201;
    name = "Aidan Gauland";
  };
  aij = {
    email = "aij+git@mrph.org";
    github = "aij";
    githubId = 4732885;
    name = "Ivan Jager";
  };
  aiotter = {
    email = "git@aiotter.com";
    github = "aiotter";
    githubId = 37664775;
    name = "Yuto Oguchi";
  };
  airwoodix = {
    email = "airwoodix@posteo.me";
    github = "airwoodix";
    githubId = 44871469;
    name = "Etienne Wodey";
  };
  ajs124 = {
    email = "nix@ajs124.de";
    matrix = "@andreas.schraegle:helsinki-systems.de";
    github = "ajs124";
    githubId = 1229027;
    name = "Andreas Schrägle";
  };
  ajgrf = {
    email = "a@ajgrf.com";
    github = "ajgrf";
    githubId = 10733175;
    name = "Alex Griffin";
  };
  ak = {
    email = "ak@formalprivacy.com";
    github = "alexanderkjeldaas";
    githubId = 339369;
    name = "Alexander Kjeldaas";
  };
  akavel = {
    email = "czapkofan@gmail.com";
    github = "akavel";
    githubId = 273837;
    name = "Mateusz Czapliński";
  };
  akamaus = {
    email = "dmitryvyal@gmail.com";
    github = "akamaus";
    githubId = 58955;
    name = "Dmitry Vyal";
  };
  akaWolf = {
    email = "akawolf0@gmail.com";
    github = "akaWolf";
    githubId = 5836586;
    name = "Artjom Vejsel";
  };
  akc = {
    email = "akc@akc.is";
    github = "akc";
    githubId = 1318982;
    name = "Anders Claesson";
  };
  akho = {
    name = "Alexander Khodyrev";
    email = "a@akho.name";
    github = "akho";
    githubId = 104951;
  };
  akkesm = {
    name = "Alessandro Barenghi";
    email = "alessandro.barenghi@tuta.io";
    github = "akkesm";
    githubId = 56970006;
    keys = [{
      fingerprint = "50E2 669C AB38 2F4A 5F72  1667 0D6B FC01 D45E DADD";
    }];
  };
  akru = {
    email = "mail@akru.me";
    github = "akru";
    githubId = 786394;
    name = "Alexander Krupenkin ";
  };
  akshgpt7 = {
    email = "akshgpt7@gmail.com";
    github = "akshgpt7";
    githubId = 20405311;
    name = "Aksh Gupta";
  };
  alapshin = {
    email = "alapshin@fastmail.com";
    github = "alapshin";
    githubId = 321946;
    name = "Andrei Lapshin";
  };
  albakham = {
    email = "dev@geber.ga";
    github = "albakham";
    githubId = 43479487;
    name = "Titouan Biteau";
  };
  alekseysidorov = {
    email = "sauron1987@gmail.com";
    github = "alekseysidorov";
    githubId = 83360;
    name = "Aleksey Sidorov";
  };
  alerque = {
    email = "caleb@alerque.com";
    github = "alerque";
    githubId = 173595;
    name = "Caleb Maclennan";
  };
  ALEX11BR = {
    email = "alexioanpopa11@gmail.com";
    github = "ALEX11BR";
    githubId = 49609151;
    name = "Popa Ioan Alexandru";
  };
  alexarice = {
    email = "alexrice999@hotmail.co.uk";
    github = "alexarice";
    githubId = 17208985;
    name = "Alex Rice";
  };
  alexbakker = {
    email = "ab@alexbakker.me";
    github = "alexbakker";
    githubId = 2387841;
    name = "Alexander Bakker";
  };
  alexbiehl = {
    email = "alexbiehl@gmail.com";
    github = "alexbiehl";
    githubId = 1876617;
    name = "Alex Biehl";
  };
  alexchapman = {
    email = "alex@farfromthere.net";
    github = "AJChapman";
    githubId = 8316672;
    name = "Alex Chapman";
  };
  alexfmpe = {
    email = "alexandre.fmp.esteves@gmail.com";
    github = "alexfmpe";
    githubId = 2335822;
    name = "Alexandre Esteves";
  };
  alexnortung = {
    name = "alexnortung";
    email = "alex_nortung@live.dk";
    github = "Alexnortung";
    githubId = 1552267;
  };
  alexshpilkin = {
    email = "ashpilkin@gmail.com";
    github = "alexshpilkin";
    githubId = 1010468;
    keys = [{
      fingerprint = "B595 D74D 6615 C010 469F  5A13 73E9 AA11 4B3A 894B";
    }];
    matrix = "@alexshpilkin:matrix.org";
    name = "Alexander Shpilkin";
  };
  alexvorobiev = {
    email = "alexander.vorobiev@gmail.com";
    github = "alexvorobiev";
    githubId = 782180;
    name = "Alex Vorobiev";
  };
  alexwinter = {
    email = "git@alexwinter.net";
    github = "lxwntr";
    githubId = 50754358;
    name = "Alex Winter";
  };
  alexeyre = {
    email = "A.Eyre@sms.ed.ac.uk";
    github = "alexeyre";
    githubId = 38869148;
    name = "Alex Eyre";
  };
  algram = {
    email = "aliasgram@gmail.com";
    github = "Algram";
    githubId = 5053729;
    name = "Alias Gram";
  };
  alibabzo = {
    email = "alistair.bill@gmail.com";
    github = "alistairbill";
    githubId = 2822871;
    name = "Alistair Bill";
  };
  alirezameskin = {
    email = "alireza.meskin@gmail.com";
    github = "alirezameskin";
    githubId = 36147;
    name = "Alireza Meskin";
  };
  alkasm = {
    email = "alexreynolds00@gmail.com";
    github = "alkasm";
    githubId = 9651002;
    name = "Alexander Reynolds";
  };
  alkeryn = {
    email = "plbraundev@gmail.com";
    github = "alkeryn";
    githubId = 11599075;
    name = "Pierre-Louis Braun";
  };
  allonsy = {
    email = "linuxbash8@gmail.com";
    github = "allonsy";
    githubId = 5892756;
    name = "Alec Snyder";
  };
  AluisioASG = {
    name = "Aluísio Augusto Silva Gonçalves";
    email = "aluisio@aasg.name";
    github = "AluisioASG";
    githubId = 1904165;
    keys = [{
      fingerprint = "7FDB 17B3 C29B 5BA6 E5A9  8BB2 9FAA 63E0 9750 6D9D";
    }];
  };
  almac = {
    email = "alma.cemerlic@gmail.com";
    github = "a1mac";
    githubId = 60479013;
    name = "Alma Cemerlic";
  };
  alternateved = {
    email = "alternateved@pm.me";
    github = "alternateved";
    githubId = 45176912;
    name = "Tomasz Hołubowicz";
  };
  alunduil = {
    email = "alunduil@gmail.com";
    github = "alunduil";
    githubId = 169249;
    name = "Alex Brandt";
  };
  alva = {
    email = "alva@skogen.is";
    github = "illfygli";
    githubId = 42881386;
    name = "Alva";
    keys = [{
      fingerprint = "B422 CFB1 C9EF 73F7 E1E2 698D F53E 3233 42F7 A6D3A";
    }];
  };
  alyaeanyx = {
    email = "alexandra.hollmeier@mailbox.org";
    github = "alyaeanyx";
    githubId = 74795488;
    name = "Alexandra Hollmeier";
    keys = [{
      fingerprint = "1F73 8879 5E5A 3DFC E2B3 FA32 87D1 AADC D25B 8DEE";
    }];
  };
  amanjeev = {
    email = "aj@amanjeev.com";
    github = "amanjeev";
    githubId = 160476;
    name = "Amanjeev Sethi";
  };
  amar1729 = {
    email = "amar.paul16@gmail.com";
    github = "Amar1729";
    githubId = 15623522;
    name = "Amar Paul";
  };
  amarshall = {
    email = "andrew@johnandrewmarshall.com";
    github = "amarshall";
    githubId = 153175;
    name = "Andrew Marshall";
  };
  ambroisie = {
    email = "bruno.nixpkgs@belanyi.fr";
    github = "ambroisie";
    githubId = 12465195;
    name = "Bruno BELANYI";
  };
  ambrop72 = {
    email = "ambrop7@gmail.com";
    github = "ambrop72";
    githubId = 2626481;
    name = "Ambroz Bizjak";
  };
  amesgen = {
    email = "amesgen@amesgen.de";
    github = "amesgen";
    githubId = 15369874;
    name = "Alexander Esgen";
    matrix = "@amesgen:amesgen.de";
  };
  ametrine = {
    name = "Matilde Ametrine";
    email = "matilde@diffyq.xyz";
    github = "matilde-ametrine";
    githubId = 90799677;
    keys = [{
      fingerprint = "7931 EB4E 4712 D7BE 04F8  6D34 07EE 1FFC A58A 11C5";
    }];
  };
  amfl = {
    email = "amfl@none.none";
    github = "amfl";
    githubId = 382798;
    name = "amfl";
  };
  amiddelk = {
    email = "amiddelk@gmail.com";
    github = "amiddelk";
    githubId = 1358320;
    name = "Arie Middelkoop";
  };
  amiloradovsky = {
    email = "miloradovsky@gmail.com";
    github = "amiloradovsky";
    githubId = 20530052;
    name = "Andrew Miloradovsky";
  };
  notbandali = {
    name = "Amin Bandali";
    email = "bandali@gnu.org";
    github = "notbandali";
    githubId = 1254858;
    keys = [{
      fingerprint = "BE62 7373 8E61 6D6D 1B3A  08E8 A21A 0202 4881 6103";
    }];
  };
  aminechikhaoui = {
    email = "amine.chikhaoui91@gmail.com";
    github = "AmineChikhaoui";
    githubId = 5149377;
    name = "Amine Chikhaoui";
  };
  amorsillo = {
    email = "andrew.morsillo@gmail.com";
    github = "evelant";
    githubId = 858965;
    name = "Andrew Morsillo";
  };
  an-empty-string = {
    name = "Tris Emmy Wilson";
    email = "tris@tris.fyi";
    github = "an-empty-string";
    githubId = 681716;
  };
  AnatolyPopov = {
    email = "aipopov@live.ru";
    github = "AnatolyPopov";
    githubId = 2312534;
    name = "Anatolii Popov";
  };
  andehen = {
    email = "git@andehen.net";
    github = "andehen";
    githubId = 754494;
    name = "Anders Asheim Hennum";
  };
  andersk = {
    email = "andersk@mit.edu";
    github = "andersk";
    githubId = 26471;
    name = "Anders Kaseorg";
  };
  anderslundstedt = {
    email = "git@anderslundstedt.se";
    github = "anderslundstedt";
    githubId = 4514101;
    name = "Anders Lundstedt";
  };
  AndersonTorres = {
    email = "torres.anderson.85@protonmail.com";
    matrix = "@anderson_torres:matrix.org";
    github = "AndersonTorres";
    githubId = 5954806;
    name = "Anderson Torres";
  };
  anderspapitto = {
    email = "anderspapitto@gmail.com";
    github = "anderspapitto";
    githubId = 1388690;
    name = "Anders Papitto";
  };
  andir = {
    email = "andreas@rammhold.de";
    github = "andir";
    githubId = 638836;
    name = "Andreas Rammhold";
  };
  andreasfelix = {
    email = "fandreas@physik.hu-berlin.de";
    github = "andreasfelix";
    githubId = 24651767;
    name = "Felix Andreas";
  };
  andres = {
    email = "ksnixos@andres-loeh.de";
    github = "kosmikus";
    githubId = 293191;
    name = "Andres Loeh";
  };
  andresilva = {
    email = "andre.beat@gmail.com";
    github = "andresilva";
    githubId = 123550;
    name = "André Silva";
  };
  andrestylianos = {
    email = "andre.stylianos@gmail.com";
    github = "andrestylianos";
    githubId = 7112447;
    name = "Andre S. Ramos";
  };
  andrevmatos = {
    email = "andrevmatos@gmail.com";
    github = "andrevmatos";
    githubId = 587021;
    name = "André V L Matos";
  };
  andrew-d = {
    email = "andrew@du.nham.ca";
    github = "andrew-d";
    githubId = 1079173;
    name = "Andrew Dunham";
  };
  andrewchambers = {
    email = "ac@acha.ninja";
    github = "andrewchambers";
    githubId = 962885;
    name = "Andrew Chambers";
  };
  andrewrk = {
    email = "superjoe30@gmail.com";
    github = "andrewrk";
    githubId = 106511;
    name = "Andrew Kelley";
  };
  andsild = {
    email = "andsild@gmail.com";
    github = "andsild";
    githubId = 3808928;
    name = "Anders Sildnes";
  };
  andys8 = {
    email = "andys8@users.noreply.github.com";
    github = "andys8";
    githubId = 13085980;
    name = "Andy";
  };
  aneeshusa = {
    email = "aneeshusa@gmail.com";
    github = "aneeshusa";
    githubId = 2085567;
    name = "Aneesh Agrawal";
  };
  angristan = {
    email = "angristan@pm.me";
    github = "angristan";
    githubId = 11699655;
    name = "Stanislas Lange";
  };
  AngryAnt = {
    name = "Emil Johansen";
    email = "git@eej.dk";
    matrix = "@angryant:envs.net";
    github = "AngryAnt";
    githubId = 102513;
    keys = [{
      fingerprint = "B7B7 582E 564E 789B FCB8  71AB 0C6D FE2F B234 534A";
    }];
  };
  anhdle14 = {
    name = "Le Anh Duc";
    email = "anhdle14@icloud.com";
    github = "anhdle14";
    githubId = 9645992;
    keys = [{
      fingerprint = "AA4B 8EC3 F971 D350 482E  4E20 0299 AFF9 ECBB 5169";
    }];
  };
  anhduy = {
    email = "vo@anhduy.io";
    github = "voanhduy1512";
    githubId = 1771266;
    name = "Vo Anh Duy";
  };
  Anillc = {
    name = "Anillc";
    email = "i@anillc.cn";
    github = "Anillc";
    githubId = 23411248;
    keys = [{
      fingerprint = "6141 1E4F FE10 CE7B 2E14  CD76 0BE8 A88F 47B2 145C";
    }];
  };
  anirrudh = {
    email = "anik597@gmail.com";
    github = "anirrudh";
    githubId = 6091755;
    name = "Anirrudh Krishnan";
  };
  ankhers = {
    email = "me@ankhers.dev";
    github = "ankhers";
    githubId = 750786;
    name = "Justin Wood";
  };
  anna328p = {
    email = "anna328p@gmail.com";
    github = "anna328p";
    githubId = 9790772;
    name = "Anna";
  };
  anmonteiro = {
    email = "anmonteiro@gmail.com";
    github = "anmonteiro";
    githubId = 661909;
    name = "Antonio Nuno Monteiro";
  };
  anoa = {
    matrix = "@andrewm:amorgan.xyz";
    email = "andrew@amorgan.xyz";
    github = "anoadragon453";
    githubId = 1342360;
    name = "Andrew Morgan";
  };
  anpryl = {
    email = "anpryl@gmail.com";
    github = "anpryl";
    githubId = 5327697;
    name = "Anatolii Prylutskyi";
  };
  anselmschueler = {
    email = "mail@anselmschueler.com";
    github = "schuelermine";
    githubId = 48802534;
    name = "Anselm Schüler";
    matrix = "@schuelermine:matrix.org";
  };
  anthonyroussel = {
    email = "anthony@roussel.dev";
    github = "anthonyroussel";
    githubId = 220084;
    name = "Anthony Roussel";
    keys = [{
      fingerprint = "472D 368A F107 F443 F3A5  C712 9DC4 987B 1A55 E75E";
    }];
  };
  antoinerg = {
    email = "roygobeil.antoine@gmail.com";
    github = "antoinerg";
    githubId = 301546;
    name = "Antoine Roy-Gobeil";
  };
  anton-dessiatov = {
    email = "anton.dessiatov@gmail.com";
    github = "anton-dessiatov";
    githubId = 2873280;
    name = "Anton Desyatov";
  };
  Anton-Latukha = {
    email = "anton.latuka+nixpkgs@gmail.com";
    github = "Anton-Latukha";
    githubId = 20933385;
    name = "Anton Latukha";
  };
  antono = {
    email = "self@antono.info";
    github = "antono";
    githubId = 7622;
    name = "Antono Vasiljev";
  };
  antonxy = {
    email = "anton.schirg@posteo.de";
    github = "antonxy";
    githubId = 4194320;
    name = "Anton Schirg";
  };
  apeschar = {
    email = "albert@peschar.net";
    github = "apeschar";
    githubId = 122977;
    name = "Albert Peschar";
  };
  apeyroux = {
    email = "alex@px.io";
    github = "apeyroux";
    githubId = 1078530;
    name = "Alexandre Peyroux";
  };
  applePrincess = {
    email = "appleprincess@appleprincess.io";
    github = "applePrincess";
    githubId = 17154507;
    name = "Lein Matsumaru";
    keys = [{
      fingerprint = "BF8B F725 DA30 E53E 7F11  4ED8 AAA5 0652 F047 9205";
    }];
  };
  apraga = {
    email = "alexis.praga@proton.me";
    github = "apraga";
    githubId = 914687;
    name = "Alexis Praga";
  };
  ar1a = {
    email = "aria@ar1as.space";
    github = "ar1a";
    githubId = 8436007;
    name = "Aria Edmonds";
  };
  arcadio = {
    email = "arc@well.ox.ac.uk";
    github = "arcadio";
    githubId = 56009;
    name = "Arcadio Rubio García";
  };
  archer-65 = {
    email = "mario.liguori.056@gmail.com";
    github = "archer-65";
    githubId = 76066109;
    name = "Mario Liguori";
  };
  archseer = {
    email = "blaz@mxxn.io";
    github = "archseer";
    githubId = 1372918;
    name = "Blaž Hrastnik";
  };
  arcnmx = {
    email = "arcnmx@users.noreply.github.com";
    github = "arcnmx";
    githubId = 13426784;
    name = "arcnmx";
  };
  arcticlimer = {
    email = "vinigm.nho@gmail.com";
    github = "viniciusmuller";
    githubId = 59743220;
    name = "Vinícius Müller";
  };
  ardumont = {
    email = "eniotna.t@gmail.com";
    github = "ardumont";
    githubId = 718812;
    name = "Antoine R. Dumont";
  };
  arezvov = {
    email = "alex@rezvov.ru";
    github = "arezvov";
    githubId = 58516559;
    name = "Alexander Rezvov";
  };
  arianvp = {
    email = "arian.vanputten@gmail.com";
    github = "arianvp";
    githubId = 628387;
    name = "Arian van Putten";
  };
  arikgrahl = {
    email = "mail@arik-grahl.de";
    github = "arikgrahl";
    githubId = 8049011;
    name = "Arik Grahl";
  };
  aristid = {
    email = "aristidb@gmail.com";
    github = "aristidb";
    githubId = 30712;
    name = "Aristid Breitkreuz";
  };
  ariutta = {
    email = "anders.riutta@gmail.com";
    github = "ariutta";
    githubId = 1296771;
    name = "Anders Riutta";
  };
  arjan-s = {
    email = "github@anymore.nl";
    github = "arjan-s";
    githubId = 10400299;
    name = "Arjan Schrijver";
  };
  arkivm = {
    email = "vikram186@gmail.com";
    github = "arkivm";
    githubId = 1118815;
    name = "Vikram Narayanan";
  };
  armeenm = {
    email = "mahdianarmeen@gmail.com";
    github = "armeenm";
    githubId = 29145250;
    name = "Armeen Mahdian";
  };
  armijnhemel = {
    email = "armijn@tjaldur.nl";
    github = "armijnhemel";
    githubId = 10587952;
    name = "Armijn Hemel";
  };
  arnarg = {
    email = "arnarg@fastmail.com";
    github = "arnarg";
    githubId = 1291396;
    name = "Arnar Ingason";
  };
  arnoldfarkas = {
    email = "arnold.farkas@gmail.com";
    github = "arnoldfarkas";
    githubId = 59696216;
    name = "Arnold Farkas";
  };
  arnoutkroeze = {
    email = "nixpkgs@arnoutkroeze.nl";
    github = "ArnoutKroeze";
    githubId = 37151054;
    name = "Arnout Kroeze";
  };
  arobyn = {
    email = "shados@shados.net";
    github = "Shados";
    githubId = 338268;
    name = "Alexei Robyn";
  };
  artemist = {
    email = "me@artem.ist";
    github = "artemist";
    githubId = 1226638;
    name = "Artemis Tosini";
    keys = [{
      fingerprint = "3D2B B230 F9FA F0C5 1832  46DD 4FDC 96F1 61E7 BA8A";
    }];
  };
  arthur = {
    email = "me@arthur.li";
    github = "arthurl";
    githubId = 3965744;
    name = "Arthur Lee";
  };
  arthurteisseire = {
    email = "arthurteisseire33@gmail.com";
    github = "arthurteisseire";
    githubId = 37193992;
    name = "Arthur Teisseire";
  };
  arturcygan = {
    email = "arczicygan@gmail.com";
    github = "arcz";
    githubId = 4679721;
    name = "Artur Cygan";
  };
  artuuge = {
    email = "artuuge@gmail.com";
    github = "artuuge";
    githubId = 10285250;
    name = "Artur E. Ruuge";
  };
  asbachb = {
    email = "asbachb-nixpkgs-5c2a@impl.it";
    matrix = "@asbachb:matrix.org";
    github = "asbachb";
    githubId = 1482768;
    name = "Benjamin Asbach";
  };
  ashalkhakov = {
    email = "artyom.shalkhakov@gmail.com";
    github = "ashalkhakov";
    githubId = 1270502;
    name = "Artyom Shalkhakov";
  };
  ashgillman = {
    email = "gillmanash@gmail.com";
    github = "ashgillman";
    githubId = 816777;
    name = "Ashley Gillman";
  };
  ashkitten = {
    email = "ashlea@protonmail.com";
    github = "ashkitten";
    githubId = 9281956;
    name = "ash lea";
  };
  aske = {
    email = "aske@fmap.me";
    github = "aske";
    githubId = 869771;
    name = "Kirill Boltaev";
  };
  ashley = {
    email = "ashley@kira64.xyz";
    github = "kira64xyz";
    githubId = 84152630;
    name = "Ashley Chiara";
  };
  asppsa = {
    email = "asppsa@gmail.com";
    github = "asppsa";
    githubId = 453170;
    name = "Alastair Pharo";
  };
  astro = {
    email = "astro@spaceboyz.net";
    github = "astro";
    githubId = 12923;
    name = "Astro";
  };
  astrobeastie = {
    email = "fischervincent98@gmail.com";
    github = "astrobeastie";
    githubId = 26362368;
    name = "Vincent Fischer";
    keys = [{
      fingerprint = "BF47 81E1 F304 1ADF 18CE  C401 DE16 C7D1 536D A72F";
    }];
  };
  astsmtl = {
    email = "astsmtl@yandex.ru";
    github = "astsmtl";
    githubId = 2093941;
    name = "Alexander Tsamutali";
  };
  asymmetric = {
    email = "lorenzo@mailbox.org";
    github = "asymmetric";
    githubId = 101816;
    name = "Lorenzo Manacorda";
  };
  aszlig = {
    email = "aszlig@nix.build";
    github = "aszlig";
    githubId = 192147;
    name = "aszlig";
    keys = [{
      fingerprint = "DD52 6BC7 767D BA28 16C0 95E5 6840 89CE 67EB B691";
    }];
  };
  ataraxiasjel = {
    email = "nix@ataraxiadev.com";
    github = "AtaraxiaSjel";
    githubId = 5314145;
    name = "Dmitriy";
    keys = [{
      fingerprint = "922D A6E7 58A0 FE4C FAB4 E4B2 FD26 6B81 0DF4 8DF2";
    }];
  };
  atemu = {
    name = "Atemu";
    email = "atemu.main+nixpkgs@gmail.com";
    github = "Atemu";
    githubId = 18599032;
  };
  athas = {
    email = "athas@sigkill.dk";
    github = "athas";
    githubId = 55833;
    name = "Troels Henriksen";
  };
  atila = {
    name = "Átila Saraiva";
    email = "atilasaraiva@gmail.com";
    github = "AtilaSaraiva";
    githubId = 29521461;
  };
  atkinschang = {
    email = "atkinschang+nixpkgs@gmail.com";
    github = "AtkinsChang";
    githubId = 5193600;
    name = "Atkins Chang";
  };
  atnnn = {
    email = "etienne@atnnn.com";
    github = "AtnNn";
    githubId = 706854;
    name = "Etienne Laurin";
  };
  atry = {
    name = "Bo Yang";
    email = "atry@fb.com";
    github = "Atry";
    githubId = 601530;
  };
  attila-lendvai = {
    name = "Attila Lendvai";
    email = "attila@lendvai.name";
    github = "attila-lendvai";
    githubId = 840345;
  };
  auchter = {
    name = "Michael Auchter";
    email = "a@phire.org";
    github = "auchter";
    githubId = 1190483;
  };
  auntie = {
    email = "auntieNeo@gmail.com";
    github = "auntieNeo";
    githubId = 574938;
    name = "Jonathan Glines";
  };
  austinbutler = {
    email = "austinabutler@gmail.com";
    github = "austinbutler";
    githubId = 354741;
    name = "Austin Butler";
  };
  autophagy = {
    email = "mail@autophagy.io";
    github = "autophagy";
    githubId = 12958979;
    name = "Mika Naylor";
  };
  avaq = {
    email = "nixpkgs@account.avaq.it";
    github = "Avaq";
    githubId = 1217745;
    name = "Aldwin Vlasblom";
  };
  aveltras = {
    email = "romain.viallard@outlook.fr";
    github = "aveltras";
    githubId = 790607;
    name = "Romain Viallard";
  };
  avery = {
    email = "averyl+nixos@protonmail.com";
    github = "AveryLychee";
    githubId = 9147625;
    name = "Avery Lychee";
  };
  averelld = {
    email = "averell+nixos@rxd4.com";
    github = "averelld";
    githubId = 687218;
    name = "averelld";
  };
  avh4 = {
    email = "gruen0aermel@gmail.com";
    github = "avh4";
    githubId = 1222;
    name = "Aaron VonderHaar";
  };
  avitex = {
    email = "theavitex@gmail.com";
    github = "avitex";
    githubId = 5110816;
    name = "avitex";
    keys = [{
      fingerprint = "271E 136C 178E 06FA EA4E  B854 8B36 6C44 3CAB E942";
    }];
  };
  avnik = {
    email = "avn@avnik.info";
    github = "avnik";
    githubId = 153538;
    name = "Alexander V. Nikolaev";
  };
  aw = {
    email = "aw-nixos@meterriblecrew.net";
    github = "herrwiese";
    githubId = 206242;
    name = "Andreas Wiese";
  };
  aycanirican = {
    email = "iricanaycan@gmail.com";
    github = "aycanirican";
    githubId = 135230;
    name = "Aycan iRiCAN";
  };
  arjix = {
    email = "arjix@protonmail.com";
    github = "arjix";
    githubId = 62168569;
    name = "arjix";
  };
  artturin = {
    email = "artturin@artturin.com";
    matrix = "@artturin:matrix.org";
    github = "Artturin";
    githubId = 56650223;
    name = "Artturi N";
  };
  azahi = {
    name = "Azat Bahawi";
    email = "azat@bahawi.net";
    matrix = "@azahi:azahi.cc";
    github = "azahi";
    githubId = 22211000;
    keys = [{
      fingerprint = "2688 0377 C31D 9E81 9BDF  83A8 C8C6 BDDB 3847 F72B";
    }];
  };
  ayazhafiz = {
    email = "ayaz.hafiz.1@gmail.com";
    github = "hafiz";
    githubId = 262763;
    name = "Ayaz Hafiz";
  };
  azuwis = {
    email = "azuwis@gmail.com";
    github = "azuwis";
    githubId = 9315;
    name = "Zhong Jianxin";
  };
  a-kenji = {
    email = "aks.kenji@protonmail.com";
    github = "a-kenji";
    githubId = 65275785;
    name = "Alexander Kenji Berthold";
  };
  b4dm4n = {
    email = "fabianm88@gmail.com";
    github = "B4dM4n";
    githubId = 448169;
    name = "Fabian Möller";
    keys = [{
      fingerprint = "6309 E212 29D4 DA30 AF24  BDED 754B 5C09 63C4 2C50";
    }];
  };
  babariviere = {
    email = "me@babariviere.com";
    github = "babariviere";
    githubId = 12128029;
    name = "Bastien Rivière";
    keys = [{
      fingerprint = "74AA 9AB4 E6FF 872B 3C5A  CB3E 3903 5CC0 B75D 1142";
    }];
  };
  babbaj = {
    name = "babbaj";
    email = "babbaj45@gmail.com";
    github = "babbaj";
    githubId = 12820770;
    keys = [{
      fingerprint = "6FBC A462 4EAF C69C A7C4  98C1 F044 3098 48A0 7CAC";
    }];
  };
  bachp = {
    email = "pascal.bach@nextrem.ch";
    matrix = "@bachp:matrix.org";
    github = "bachp";
    githubId = 333807;
    name = "Pascal Bach";
  };
  backuitist = {
    email = "biethb@gmail.com";
    github = "backuitist";
    githubId = 1017537;
    name = "Bruno Bieth";
  };
  badmutex = {
    email = "github@badi.sh";
    github = "badmutex";
    githubId = 35324;
    name = "Badi' Abdul-Wahid";
  };
  baduhai = {
    email = "baduhai@pm.me";
    github = "baduhai";
    githubId = 31864305;
    name = "William";
  };
  baitinq = {
    email = "manuelpalenzuelamerino@gmail.com";
    name = "Baitinq";
    github = "Baitinq";
    githubId = 30861839;
  };
  balodja = {
    email = "balodja@gmail.com";
    github = "balodja";
    githubId = 294444;
    name = "Vladimir Korolev";
  };
  baloo = {
    email = "nixpkgs@superbaloo.net";
    github = "baloo";
    githubId = 59060;
    name = "Arthur Gautier";
  };
  balsoft = {
    email = "balsoft75@gmail.com";
    github = "balsoft";
    githubId = 18467667;
    name = "Alexander Bantyev";
  };
  bandresen = {
    email = "bandresen@gmail.com";
    github = "bennyandresen";
    githubId = 80325;
    name = "Benjamin Andresen";
  };
  baracoder = {
    email = "baracoder@googlemail.com";
    github = "baracoder";
    githubId = 127523;
    name = "Herman Fries";
  };
  BarinovMaxim = {
    name = "Barinov Maxim";
    email = "barinov274@gmail.com";
    github = "barinov274";
    githubId = 54442153;
  };
  barrucadu = {
    email = "mike@barrucadu.co.uk";
    github = "barrucadu";
    githubId = 75235;
    name = "Michael Walker";
  };
  bartsch = {
    email = "consume.noise@gmail.com";
    github = "bartsch";
    githubId = 3390885;
    name = "Daniel Martin";
  };
  bartuka = {
    email = "wand@hey.com";
    github = "wandersoncferreira";
    githubId = 17708295;
    name = "Wanderson Ferreira";
    keys = [{
      fingerprint = "A3E1 C409 B705 50B3 BF41  492B 5684 0A61 4DBE 37AE";
    }];
  };
  basvandijk = {
    email = "v.dijk.bas@gmail.com";
    github = "basvandijk";
    githubId = 576355;
    name = "Bas van Dijk";
  };
  BattleCh1cken = {
    email = "BattleCh1cken@larkov.de";
    github = "BattleCh1cken";
    githubId = 75806385;
    name = "Felix Hass";
  };
  Baughn = {
    email = "sveina@gmail.com";
    github = "Baughn";
    githubId = 45811;
    name = "Svein Ove Aas";
  };
  bb010g = {
    email = "me@bb010g.com";
    matrix = "@bb010g:matrix.org";
    github = "bb010g";
    githubId = 340132;
    name = "Brayden Banks";
  };
  bbarker = {
    email = "brandon.barker@gmail.com";
    github = "bbarker";
    githubId = 916366;
    name = "Brandon Elam Barker";
  };
  bbenno = {
    email = "nix@bbenno.com";
    github = "bbenno";
    githubId = 32938211;
    name = "Benno Bielmeier";
  };
  bbigras = {
    email = "bigras.bruno@gmail.com";
    github = "bbigras";
    githubId = 24027;
    name = "Bruno Bigras";
  };
  bcarrell = {
    email = "brandoncarrell@gmail.com";
    github = "bcarrell";
    githubId = 1015044;
    name = "Brandon Carrell";
  };
  bcc32 = {
    email = "me@bcc32.com";
    github = "bcc32";
    githubId = 1239097;
    name = "Aaron Zeng";
  };
  bcdarwin = {
    email = "bcdarwin@gmail.com";
    github = "bcdarwin";
    githubId = 164148;
    name = "Ben Darwin";
  };
  bdd = {
    email = "bdd@mindcast.org";
    github = "bdd";
    githubId = 11135;
    name = "Berk D. Demir";
  };
  bdesham = {
    email = "benjamin@esham.io";
    github = "bdesham";
    githubId = 354230;
    name = "Benjamin Esham";
  };
  bdimcheff = {
    email = "brandon@dimcheff.com";
    github = "bdimcheff";
    githubId = 14111;
    name = "Brandon Dimcheff";
  };
  beardhatcode = {
    name = "Robbert Gurdeep Singh";
    email = "nixpkgs@beardhatcode.be";
    github = "beardhatcode";
    githubId = 662538;
  };
  beezow = {
    name = "beezow";
    email = "zbeezow@gmail.com";
    github = "beezow";
    githubId = 42082156;
  };
  bendlas = {
    email = "herwig@bendlas.net";
    matrix = "@bendlas:matrix.org";
    github = "bendlas";
    githubId = 214787;
    name = "Herwig Hochleitner";
  };
  benediktbroich = {
    name = "Benedikt Broich";
    email = "b.broich@posteo.de";
    github = "BenediktBroich";
    githubId = 32903896;
    keys = [{
      fingerprint = "CB5C 7B3C 3E6F 2A59 A583  A90A 8A60 0376 7BE9 5976";
    }];
  };
  benesim = {
    name = "Benjamin Isbarn";
    email = "benjamin.isbarn@gmail.com";
    github = "benesim";
    githubId = 29384538;
    keys = [{
      fingerprint = "D35E C9CE E631 638F F1D8  B401 6F0E 410D C3EE D02";
    }];
  };
  benjaminedwardwebb = {
    name = "Ben Webb";
    email = "benjaminedwardwebb@gmail.com";
    github = "benjaminedwardwebb";
    githubId = 7118777;
    keys = [{
      fingerprint = "E9A3 7864 2165 28CE 507C  CA82 72EA BF75 C331 CD25";
    }];
  };
  benley = {
    email = "benley@gmail.com";
    github = "benley";
    githubId = 1432730;
    name = "Benjamin Staffin";
  };
  benneti = {
    name = "Benedikt Tissot";
    email = "benedikt.tissot@googlemail.com";
    github = "benneti";
    githubId = 11725645;
  };
  bertof = {
    name = "Filippo Berto";
    email = "berto.f@protonmail.com";
    github = "bertof";
    githubId = 9915675;
    keys = [{
      fingerprint = "17C5 1EF9 C0FE 2EB2 FE56  BB53 FE98 AE5E C52B 1056";
    }];
  };
  bennofs = {
    email = "benno.fuenfstueck@gmail.com";
    github = "bennofs";
    githubId = 3192959;
    name = "Benno Fünfstück";
  };
  benpye = {
    email = "ben@curlybracket.co.uk";
    github = "benpye";
    githubId = 442623;
    name = "Ben Pye";
  };
  berberman = {
    email = "berberman@yandex.com";
    matrix = "@berberman:mozilla.org";
    github = "berberman";
    githubId = 26041945;
    name = "Potato Hatsue";
  };
  berce = {
    email = "bert.moens@gmail.com";
    github = "berce";
    githubId = 10439709;
    name = "Bert Moens";
  };
  berdario = {
    email = "berdario@gmail.com";
    github = "berdario";
    githubId = 752835;
    name = "Dario Bertini";
  };
  bergey = {
    email = "bergey@teallabs.org";
    github = "bergey";
    githubId = 251106;
    name = "Daniel Bergey";
  };
  bergkvist = {
    email = "tobias@bergkv.ist";
    github = "bergkvist";
    githubId = 410028;
    name = "Tobias Bergkvist";
  };
  berryp = {
    email = "berryphillips@gmail.com";
    github = "berryp";
    githubId = 19911;
    name = "Berry Phillips";
  };
  betaboon = {
    email = "betaboon@0x80.ninja";
    github = "betaboon";
    githubId = 7346933;
    name = "betaboon";
  };
  bew = {
    email = "benoit.dechezelles@gmail.com";
    github = "bew";
    githubId = 9730330;
    name = "Benoit de Chezelles";
  };
  bfortz = {
    email = "bernard.fortz@gmail.com";
    github = "bfortz";
    githubId = 16426882;
    name = "Bernard Fortz";
  };
  bgamari = {
    email = "ben@smart-cactus.org";
    github = "bgamari";
    githubId = 1010174;
    name = "Ben Gamari";
  };
  bhall = {
    email = "brendan.j.hall@bath.edu";
    github = "brendan-hall";
    githubId = 34919100;
    name = "Brendan Hall";
  };
  bhipple = {
    email = "bhipple@protonmail.com";
    github = "bhipple";
    githubId = 2071583;
    name = "Benjamin Hipple";
  };
  bhougland = {
    email = "benjamin.hougland@gmail.com";
    github = "bhougland18";
    githubId = 28444296;
    name = "Benjamin Hougland";
  };
  bigzilla = {
    email = "m.billyzaelani@gmail.com";
    github = "bigzilla";
    githubId = 20436235;
    name = "Billy Zaelani Malik";
  };
  billewanick = {
    email = "bill@ewanick.com";
    github = "billewanick";
    githubId = 13324165;
    name = "Bill Ewanick";
  };
  billhuang = {
    email = "bill.huang2001@gmail.com";
    github = "BillHuang2001";
    githubId = 11801831;
    name = "Bill Huang";
  };
  binarin = {
    email = "binarin@binarin.ru";
    github = "binarin";
    githubId = 185443;
    name = "Alexey Lebedeff";
  };
  binsky = {
    email = "timo@binsky.org";
    github = "binsky08";
    githubId = 30630233;
    name = "Timo Triebensky";
  };
  bjornfor = {
    email = "bjorn.forsman@gmail.com";
    github = "bjornfor";
    githubId = 133602;
    name = "Bjørn Forsman";
  };
  bkchr = {
    email = "nixos@kchr.de";
    github = "bkchr";
    githubId = 5718007;
    name = "Bastian Köcher";
  };
  blaggacao = {
    name = "David Arnold";
    email = "dar@xoe.solutions";
    github = "blaggacao";
    githubId = 7548295;
  };
  blanky0230 = {
    email = "blanky0230@gmail.com";
    github = "blanky0230";
    githubId = 5700358;
    name = "Thomas Blank";
  };
  blitz = {
    email = "js@alien8.de";
    matrix = "@js:ukvly.org";
    github = "blitz";
    githubId = 37907;
    name = "Julian Stecklina";
  };
  bluescreen303 = {
    email = "mathijs@bluescreen303.nl";
    github = "bluescreen303";
    githubId = 16330;
    name = "Mathijs Kwik";
  };
  bmilanov = {
    name = "Biser Milanov";
    email = "bmilanov11+nixpkgs@gmail.com";
    github = "bmilanov";
    githubId = 30090366;
  };
  bmwalters = {
    name = "Bradley Walters";
    email = "oss@walters.app";
    github = "bmwalters";
    githubId = 4380777;
  };
  bobakker = {
    email = "bobakk3r@gmail.com";
    github = "bobakker";
    githubId = 10221570;
    name = "Bo Bakker";
  };
  bobby285271 = {
    name = "Bobby Rong";
    email = "rjl931189261@126.com";
    matrix = "@bobby285271:matrix.org";
    github = "bobby285271";
    githubId = 20080233;
  };
  bobvanderlinden = {
    email = "bobvanderlinden@gmail.com";
    github = "bobvanderlinden";
    githubId = 6375609;
    name = "Bob van der Linden";
  };
  bodil = {
    email = "nix@bodil.org";
    github = "bodil";
    githubId = 17880;
    name = "Bodil Stokke";
  };
  boj = {
    email = "brian@uncannyworks.com";
    github = "boj";
    githubId = 50839;
    name = "Brian Jones";
  };
  booklearner = {
    name = "booklearner";
    email = "booklearner@proton.me";
    matrix = "@booklearner:matrix.org";
    github = "booklearner";
    githubId = 103979114;
    keys = [{
      fingerprint = "17C7 95D4 871C 2F87 83C8  053D 0C61 C4E5 907F 76C8";
    }];
  };
  bootstrap-prime = {
    email = "bootstrap.prime@gmail.com";
    github = "bootstrap-prime";
    githubId = 68566724;
    name = "bootstrap-prime";
  };
  commandodev = {
    email = "ben@perurbis.com";
    github = "commandodev";
    githubId = 87764;
    name = "Ben Ford";
  };
  boppyt = {
    email = "boppy@nwcpz.com";
    github = "boppyt";
    githubId = 71049646;
    name = "Zack A";
    keys = [{
      fingerprint = "E8D7 5C19 9F65 269B 439D  F77B 6310 C97D E31D 1545";
    }];
  };
  borisbabic = {
    email = "boris.ivan.babic@gmail.com";
    github = "borisbabic";
    githubId = 1743184;
    name = "Boris Babić";
  };
  borlaag = {
    email = "borlaag@proton.me";
    github = "Borlaag";
    githubId = 114830266;
    name = "Børlaag";
  };
  bosu = {
    email = "boriss@gmail.com";
    github = "bosu";
    githubId = 3465841;
    name = "Boris Sukholitko";
  };
  bouk = {
    name = "Bouke van der Bijl";
    email = "i@bou.ke";
    github = "bouk";
    githubId = 97820;
  };
  bradediger = {
    email = "brad@bradediger.com";
    github = "bradediger";
    githubId = 4621;
    name = "Brad Ediger";
  };
  brainrape = {
    email = "martonboros@gmail.com";
    github = "brainrake";
    githubId = 302429;
    name = "Marton Boros";
  };
  bramd = {
    email = "bram@bramd.nl";
    github = "bramd";
    githubId = 86652;
    name = "Bram Duvigneau";
  };
  braydenjw = {
    email = "nixpkgs@willenborg.ca";
    github = "braydenjw";
    githubId = 2506621;
    name = "Brayden Willenborg";
  };
  brendanreis = {
    email = "brendanreis@gmail.com";
    name = "Brendan Reis";
    github = "brendanreis";
    githubId = 10686906;
  };
  brian-dawn = {
    email = "brian.t.dawn@gmail.com";
    github = "brian-dawn";
    githubId = 1274409;
    name = "Brian Dawn";
  };
  brianhicks = {
    email = "brian@brianthicks.com";
    github = "BrianHicks";
    githubId = 355401;
    name = "Brian Hicks";
  };
  brianmcgee = {
    name = "Brian McGee";
    email = "brian@41north.dev";
    github = "brianmcgee";
    githubId = 1173648;
  };
  Br1ght0ne = {
    email = "brightone@protonmail.com";
    github = "Br1ght0ne";
    githubId = 12615679;
    name = "Oleksii Filonenko";
    keys = [{
      fingerprint = "F549 3B7F 9372 5578 FDD3  D0B8 A1BC 8428 323E CFE8";
    }];
  };
  bsima = {
    email = "ben@bsima.me";
    github = "bsima";
    githubId = 200617;
    name = "Ben Sima";
  };
  bstrik = {
    email = "dutchman55@gmx.com";
    github = "bstrik";
    githubId = 7716744;
    name = "Berno Strik";
  };
  breakds = {
    email = "breakds@gmail.com";
    github = "breakds";
    githubId = 1111035;
    name = "Break Yang";
  };
  brecht = {
    email = "brecht.savelkoul@alumni.lse.ac.uk";
    github = "brechtcs";
    githubId = 6107054;
    name = "Brecht Savelkoul";
  };
  brettlyons = {
    email = "blyons@fastmail.com";
    github = "brettlyons";
    githubId = 3043718;
    name = "Brett Lyons";
  };
  brodes = {
    email = "me@brod.es";
    github = "brhoades";
    githubId = 4763746;
    name = "Billy Rhoades";
    keys = [{
      fingerprint = "BF4FCB85C69989B4ED95BF938AE74787A4B7C07E";
    }];
  };
  broke = {
    email = "broke@in-fucking.space";
    github = "broke";
    githubId = 1071610;
    name = "Gunnar Nitsche";
  };
  bryanasdev000 = {
    email = "bryanasdev000@gmail.com";
    matrix = "@bryanasdev000:matrix.org";
    github = "bryanasdev000";
    githubId = 53131727;
    name = "Bryan Albuquerque";
  };
  btlvr = {
    email = "btlvr@protonmail.com";
    github = "btlvr";
    githubId = 32319131;
    name = "Brett L";
  };
  buckley310 = {
    email = "sean.bck@gmail.com";
    matrix = "@buckley310:matrix.org";
    github = "buckley310";
    githubId = 2379774;
    name = "Sean Buckley";
  };
  buffet = {
    email = "niclas@countingsort.com";
    github = "buffet";
    githubId = 33751841;
    name = "Niclas Meyer";
  };
  bugworm = {
    email = "bugworm@zoho.com";
    github = "bugworm";
    githubId = 7214361;
    name = "Roman Gerasimenko";
  };
  builditluc = {
    email = "builditluc@icloud.com";
    github = "Builditluc";
    githubId = 37375448;
    name = "Buildit";
  };
  bburdette = {
    email = "bburdette@protonmail.com";
    github = "bburdette";
    githubId = 157330;
    name = "Ben Burdette";
  };
  bwlang = {
    email = "brad@langhorst.com";
    github = "bwlang";
    githubId = 61636;
    name = "Brad Langhorst";
  };
  bzizou = {
    email = "Bruno@bzizou.net";
    github = "bzizou";
    githubId = 2647566;
    name = "Bruno Bzeznik";
  };
  c0bw3b = {
    email = "c0bw3b@gmail.com";
    github = "c0bw3b";
    githubId = 24417923;
    name = "Renaud";
  };
  c00w = {
    email = "nix@daedrum.net";
    github = "c00w";
    githubId = 486199;
    name = "Colin";
  };
  c0deaddict = {
    email = "josvanbakel@protonmail.com";
    github = "c0deaddict";
    githubId = 510553;
    name = "Jos van Bakel";
  };
  c4605 = {
    email = "bolasblack@gmail.com";
    github = "bolasblack";
    githubId = 382011;
    name = "c4605";
  };
  caadar = {
    email = "v88m@posteo.net";
    github = "caadar";
    githubId = 15320726;
    name = "Car Cdr";
  };
  cab404 = {
    email = "cab404@mailbox.org";
    github = "cab404";
    githubId = 6453661;
    name = "Vladimir Serov";
    keys = [
      # compare with https://keybase.io/cab404
      {
        fingerprint = "1BB96810926F4E715DEF567E6BA7C26C3FDF7BB3";
      }
      {
        fingerprint = "1EBC648C64D6045463013B3EB7EFFC271D55DB8A";
      }
    ];
  };
  calbrecht = {
    email = "christian.albrecht@mayflower.de";
    github = "calbrecht";
    githubId = 1516457;
    name = "Christian Albrecht";
  };
  CactiChameleon9 = {
    email = "h19xjkkp@duck.com";
    github = "CactiChameleon9";
    githubId = 51231053;
    name = "Daniel";
  };
  calavera = {
    email = "david.calavera@gmail.com";
    github = "calavera";
    githubId = 1050;
    matrix = "@davidcalavera:matrix.org";
    name = "David Calavera";
  };
  callahad = {
    email = "dan.callahan@gmail.com";
    github = "callahad";
    githubId = 24193;
    name = "Dan Callahan";
  };
  calvertvl = {
    email = "calvertvl@gmail.com";
    github = "calvertvl";
    githubId = 7435854;
    name = "Victor Calvert";
  };
  cameronfyfe = {
    email = "cameron.j.fyfe@gmail.com";
    github = "cameronfyfe";
    githubId = 21013281;
    name = "Cameron Fyfe";
  };
  cameronnemo = {
    email = "cnemo@tutanota.com";
    github = "CameronNemo";
    githubId = 3212452;
    name = "Cameron Nemo";
  };
  campadrenalin = {
    email = "campadrenalin@gmail.com";
    github = "campadrenalin";
    githubId = 289492;
    name = "Philip Horger";
  };
  candeira = {
    email = "javier@candeira.com";
    github = "candeira";
    githubId = 91694;
    name = "Javier Candeira";
  };
  candyc1oud = {
    email = "candyc1oud@outlook.com";
    github = "candyc1oud";
    githubId = 113157395;
    name = "Candy Cloud";
  };
  canndrew = {
    email = "shum@canndrew.org";
    github = "canndrew";
    githubId = 5555066;
    name = "Andrew Cann";
  };
  cap = {
    name = "cap";
    email = "nixos_xasenw9@digitalpostkasten.de";
    github = "scaredmushroom";
    githubId = 45340040;
  };
  CaptainJawZ = {
    email = "CaptainJawZ@outlook.com";
    name = "Danilo Reyes";
    github = "CaptainJawZ";
    githubId = 43111068;
  };
  carlosdagos = {
    email = "m@cdagostino.io";
    github = "carlosdagos";
    githubId = 686190;
    name = "Carlos D'Agostino";
  };
  carlsverre = {
    email = "accounts@carlsverre.com";
    github = "carlsverre";
    githubId = 82591;
    name = "Carl Sverre";
  };
  carpinchomug = {
    email = "aki.suda@protonmail.com";
    github = "carpinchomug";
    githubId = 101536256;
    name = "Akiyoshi Suda";
  };
  cartr = {
    email = "carter.sande@duodecima.technology";
    github = "cartr";
    githubId = 5241813;
    name = "Carter Sande";
  };
  casey = {
    email = "casey@rodarmor.net";
    github = "casey";
    githubId = 1945;
    name = "Casey Rodarmor";
  };
  catap = {
    email = "kirill@korins.ky";
    github = "catap";
    githubId = 37775;
    name = "Kirill A. Korinsky";
  };
  catern = {
    email = "sbaugh@catern.com";
    github = "catern";
    githubId = 5394722;
    name = "Spencer Baugh";
  };
  catouc = {
    email = "catouc@philipp.boeschen.me";
    github = "catouc";
    githubId = 25623213;
    name = "Philipp Böschen";
  };
  caugner = {
    email = "nixos@caugner.de";
    github = "caugner";
    githubId = 495429;
    name = "Claas Augner";
  };
  cawilliamson = {
    email = "home@chrisaw.com";
    github = "cawilliamson";
    githubId = 1141769;
    matrix = "@cawilliamson:nixos.dev";
    name = "Christopher A. Williamson";
  };
  cbley = {
    email = "claudio.bley@gmail.com";
    github = "avdv";
    githubId = 3471749;
    name = "Claudio Bley";
  };
  cburstedde = {
    email = "burstedde@ins.uni-bonn.de";
    github = "cburstedde";
    githubId = 109908;
    name = "Carsten Burstedde";
    keys = [{
      fingerprint = "1127 A432 6524 BF02 737B  544E 0704 CD9E 550A 6BCD";
    }];
  };
  cdepillabout = {
    email = "cdep.illabout@gmail.com";
    matrix = "@cdepillabout:matrix.org";
    github = "cdepillabout";
    githubId = 64804;
    name = "Dennis Gosnell";
  };
  ccellado = {
    email = "annplague@gmail.com";
    github = "ccellado";
    githubId = 44584960;
    name = "Denis Khalmatov";
  };
  ceedubs = {
    email = "ceedubs@gmail.com";
    github = "ceedubs";
    githubId = 977929;
    name = "Cody Allen";
  };
  centromere = {
    email = "nix@centromere.net";
    github = "centromere";
    githubId = 543423;
    name = "Alex Wied";
  };
  cfhammill = {
    email = "cfhammill@gmail.com";
    github = "cfhammill";
    githubId = 7467038;
    name = "Chris Hammill";
  };
  cfouche = {
    email = "chaddai.fouche@gmail.com";
    github = "Chaddai";
    githubId = 5771456;
    name = "Chaddaï Fouché";
  };
  cfsmp3 = {
    email = "carlos@sanz.dev";
    github = "cfsmp3";
    githubId = 5949913;
    name = "Carlos Fernandez Sanz";
  };
  cge = {
    email = "cevans@evanslabs.org";
    github = "cgevans";
    githubId = 2054509;
    name = "Constantine Evans";
    keys = [
      {
        fingerprint = "32B1 6EE7 DBA5 16DE 526E  4C5A B67D B1D2 0A93 A9F9";
      }
      {
        fingerprint = "669C 1D24 5A87 DB34 6BE4  3216 1A1D 58B8 6AE2 AABD";
      }
    ];
  };
  chaduffy = {
    email = "charles@dyfis.net";
    github = "charles-dyfis-net";
    githubId = 22370;
    name = "Charles Duffy";
  };
  changlinli = {
    email = "mail@changlinli.com";
    github = "changlinli";
    githubId = 1762540;
    name = "Changlin Li";
  };
  chanley = {
    email = "charlieshanley@gmail.com";
    github = "charlieshanley";
    githubId = 8228888;
    name = "Charlie Hanley";
  };
  charlesbaynham = {
    email = "charlesbaynham@gmail.com";
    github = "charlesbaynham";
    githubId = 4397637;
    name = "Charles Baynham";
  };
  CharlesHD = {
    email = "charleshdespointes@gmail.com";
    github = "CharlesHD";
    githubId = 6608071;
    name = "Charles Huyghues-Despointes";
  };
  chaoflow = {
    email = "flo@chaoflow.net";
    github = "chaoflow";
    githubId = 89596;
    name = "Florian Friesdorf";
  };
  chekoopa = {
    email = "chekoopa@mail.ru";
    github = "chekoopa";
    githubId = 1689801;
    name = "Mikhail Chekan";
  };
  ChengCat = {
    email = "yu@cheng.cat";
    github = "ChengCat";
    githubId = 33503784;
    name = "Yucheng Zhang";
  };
  cheriimoya = {
    email = "github@hausch.xyz";
    github = "cheriimoya";
    githubId = 28303440;
    name = "Max Hausch";
  };
  chessai = {
    email = "chessai1996@gmail.com";
    github = "chessai";
    githubId = 18648043;
    name = "Daniel Cartwright";
  };
  Chili-Man = {
    email = "dr.elhombrechile@gmail.com";
    name = "Diego Rodriguez";
    github = "Chili-Man";
    githubId = 631802;
    keys = [{
      fingerprint = "099E 3F97 FA08 3D47 8C75  EBEC E0EB AD78 F019 0BD9";
    }];
  };
  chiroptical = {
    email = "chiroptical@gmail.com";
    github = "chiroptical";
    githubId = 3086255;
    name = "Barry Moore II";
  };
  chisui = {
    email = "chisui.pd@gmail.com";
    github = "chisui";
    githubId = 4526429;
    name = "Philipp Dargel";
  };
  chivay = {
    email = "hubert.jasudowicz@gmail.com";
    github = "chivay";
    githubId = 14790226;
    name = "Hubert Jasudowicz";
  };
  chkno = {
    email = "chuck@intelligence.org";
    github = "chkno";
    githubId = 1118859;
    name = "Scott Worley";
  };
  choochootrain = {
    email = "hurshal@imap.cc";
    github = "choochootrain";
    githubId = 803961;
    name = "Hurshal Patel";
  };
  chpatrick = {
    email = "chpatrick@gmail.com";
    github = "chpatrick";
    githubId = 832719;
    name = "Patrick Chilton";
  };
  chreekat = {
    email = "b@chreekat.net";
    github = "chreekat";
    githubId = 538538;
    name = "Bryan Richter";
  };
  chris-martin = {
    email = "ch.martin@gmail.com";
    github = "chris-martin";
    githubId = 399718;
    name = "Chris Martin";
  };
  chrisjefferson = {
    email = "chris@bubblescope.net";
    github = "ChrisJefferson";
    githubId = 811527;
    name = "Christopher Jefferson";
  };
  chrispattison = {
    email = "chpattison@gmail.com";
    github = "ChrisPattison";
    githubId = 641627;
    name = "Chris Pattison";
  };
  chrispickard = {
    email = "chrispickard9@gmail.com";
    github = "chrispickard";
    githubId = 1438690;
    name = "Chris Pickard";
  };
  chrisrosset = {
    email = "chris@rosset.org.uk";
    github = "chrisrosset";
    githubId = 1103294;
    name = "Christopher Rosset";
  };
  christianharke = {
    email = "christian@harke.ch";
    github = "christianharke";
    githubId = 13007345;
    name = "Christian Harke";
    keys = [{
      fingerprint = "4EBB 30F1 E89A 541A A7F2  52BE 830A 9728 6309 66F4";
    }];
  };
  christophcharles = {
    email = "23055925+christophcharles@users.noreply.github.com";
    github = "christophcharles";
    githubId = 23055925;
    name = "Christoph Charles";
  };
  christopherpoole = {
    email = "mail@christopherpoole.net";
    github = "christopherpoole";
    githubId = 2245737;
    name = "Christopher Mark Poole";
  };
  chuahou = {
    email = "human+github@chuahou.dev";
    github = "chuahou";
    githubId = 12386805;
    name = "Chua Hou";
  };
  chuangzhu = {
    name = "Chuang Zhu";
    email = "chuang@melty.land";
    matrix = "@chuangzhu:matrix.org";
    github = "chuangzhu";
    githubId = 31200881;
    keys = [{
      fingerprint = "5D03 A5E6 0754 A3E3 CA57 5037 E838 CED8 1CFF D3F9";
    }];
  };
  chvp = {
    email = "nixpkgs@cvpetegem.be";
    matrix = "@charlotte:vanpetegem.me";
    github = "chvp";
    githubId = 42220376;
    name = "Charlotte Van Petegem";
  };
  ciferkey = {
    name = "Matthew Brunelle";
    email = "ciferkey@gmail.com";
    github = "ciferkey";
    githubId = 101422;
  };
  cigrainger = {
    name = "Christopher Grainger";
    email = "chris@amplified.ai";
    github = "cigrainger";
    githubId = 3984794;
  };
  ciil = {
    email = "simon@lackerbauer.com";
    github = "ciil";
    githubId = 3956062;
    name = "Simon Lackerbauer";
  };
  cimm = {
    email = "8k9ft8m5gv@astil.be";
    github = "cimm";
    githubId = 68112;
    name = "Simon";
  };
  cirno-999 = {
    email = "reverene@protonmail.com";
    github = "cirno-999";
    githubId = 73712874;
    name = "cirno-999";
  };
  citadelcore = {
    email = "alex@arctarus.co.uk";
    github = "CitadelCore";
    githubId = 5567402;
    name = "Alex Zero";
    keys = [{
      fingerprint = "A0AA 4646 B8F6 9D45 4553  5A88 A515 50ED B450 302C";
    }];
  };
  cizra = {
    email = "todurov+nix@gmail.com";
    github = "cizra";
    githubId = 2131991;
    name = "Elmo Todurov";
  };
  cjab = {
    email = "chad+nixpkgs@jablonski.xyz";
    github = "cjab";
    githubId = 136485;
    name = "Chad Jablonski";
  };
  ck3d = {
    email = "ck3d@gmx.de";
    github = "ck3d";
    githubId = 25088352;
    name = "Christian Kögler";
  };
  ckie = {
    email = "nixpkgs-0efe364@ckie.dev";
    github = "ckiee";
    githubId = 25263210;
    keys = [{
      fingerprint = "539F 0655 4D35 38A5 429A  E253 13E7 9449 C052 5215";
    }];
    name = "ckie";
    matrix = "@ckie:ckie.dev";
  };
  clkamp = {
    email = "c@lkamp.de";
    github = "clkamp";
    githubId = 46303707;
    name = "Christian Lütke-Stetzkamp";
  };
  ckauhaus = {
    email = "kc@flyingcircus.io";
    github = "ckauhaus";
    githubId = 1448923;
    name = "Christian Kauhaus";
  };
  cko = {
    email = "christine.koppelt@gmail.com";
    github = "cko";
    githubId = 68239;
    name = "Christine Koppelt";
  };
  clacke = {
    email = "claes.wallin@greatsinodevelopment.com";
    github = "clacke";
    githubId = 199180;
    name = "Claes Wallin";
  };
  cleeyv = {
    email = "cleeyv@riseup.net";
    github = "cleeyv";
    githubId = 71959829;
    name = "Cleeyv";
  };
  clerie = {
    email = "nix@clerie.de";
    github = "clerie";
    githubId = 9381848;
    name = "clerie";
  };
  cleverca22 = {
    email = "cleverca22@gmail.com";
    matrix = "@cleverca22:matrix.org";
    github = "cleverca22";
    githubId = 848609;
    name = "Michael Bishop";
  };
  cmacrae = {
    email = "hi@cmacr.ae";
    github = "cmacrae";
    githubId = 3392199;
    name = "Calum MacRae";
  };
  cmars = {
    email = "nix@cmars.tech";
    github = "cmars";
    githubId = 23741;
    name = "Casey Marshall";
    keys = [{
      fingerprint = "6B78 7E5F B493 FA4F D009  5D10 6DEC 2758 ACD5 A973";
    }];
  };
  cmcdragonkai = {
    email = "roger.qiu@matrix.ai";
    github = "CMCDragonkai";
    githubId = 640797;
    name = "Roger Qiu";
  };
  cmfwyp = {
    email = "cmfwyp@riseup.net";
    github = "cmfwyp";
    githubId = 20808761;
    name = "cmfwyp";
  };
  cmm = {
    email = "repo@cmm.kakpryg.net";
    github = "cmm";
    githubId = 718298;
    name = "Michael Livshin";
  };
  cobbal = {
    email = "andrew.cobb@gmail.com";
    github = "cobbal";
    githubId = 180339;
    name = "Andrew Cobb";
  };
  coconnor = {
    email = "coreyoconnor@gmail.com";
    github = "coreyoconnor";
    githubId = 34317;
    name = "Corey O'Connor";
  };
  CodeLongAndProsper90 = {
    github = "CodeLongAndProsper90";
    githubId = 50145141;
    email = "jupiter@m.rdis.dev";
    name = "Scott Little";
  };
  codsl = {
    email = "codsl@riseup.net";
    github = "codsl";
    githubId = 6402559;
    name = "codsl";
  };
  codyopel = {
    email = "codyopel@gmail.com";
    github = "codyopel";
    githubId = 5561189;
    name = "Cody Opel";
  };
  cofob = {
    name = "Egor Ternovoy";
    email = "cofob@riseup.net";
    matrix = "@cofob:matrix.org";
    github = "cofob";
    githubId = 49928332;
    keys = [{
      fingerprint = "5F3D 9D3D ECE0 8651 DE14  D29F ACAD 4265 E193 794D";
    }];
  };
  Cogitri = {
    email = "oss@cogitri.dev";
    github = "Cogitri";
    githubId = 8766773;
    matrix = "@cogitri:cogitri.dev";
    name = "Rasmus Thomsen";
  };
  cohei = {
    email = "a.d.xvii.kal.mai@gmail.com";
    github = "cohei";
    githubId = 3477497;
    name = "TANIGUCHI Kohei";
  };
  cohencyril = {
    email = "cyril.cohen@inria.fr";
    github = "CohenCyril";
    githubId = 298705;
    name = "Cyril Cohen";
  };
  colemickens = {
    email = "cole.mickens@gmail.com";
    matrix = "@colemickens:matrix.org";
    github = "colemickens";
    githubId = 327028;
    name = "Cole Mickens";
  };
  colescott = {
    email = "colescottsf@gmail.com";
    github = "colescott";
    githubId = 5684605;
    name = "Cole Scott";
  };
  cole-h = {
    name = "Cole Helbling";
    email = "cole.e.helbling@outlook.com";
    matrix = "@cole-h:matrix.org";
    github = "cole-h";
    githubId = 28582702;
    keys = [{
      fingerprint = "68B8 0D57 B2E5 4AC3 EC1F  49B0 B37E 0F23 7101 6A4C";
    }];
  };
  colinsane = {
    name = "Colin Sane";
    email = "colin@uninsane.org";
    matrix = "@colin:uninsane.org";
    github = "uninsane";
    githubId = 106709944;
  };
  collares = {
    email = "mauricio@collares.org";
    github = "collares";
    githubId = 244239;
    name = "Mauricio Collares";
  };
  CompEng0001 = {
    email = "sb1501@canterbury.ac.uk";
    github = "CompEng0001";
    githubId = 40290417;
    name = "Seb Blair";
  };
  considerate = {
    email = "viktor.kronvall@gmail.com";
    github = "considerate";
    githubId = 217918;
    name = "Viktor Kronvall";
  };
  copumpkin = {
    email = "pumpkingod@gmail.com";
    github = "copumpkin";
    githubId = 2623;
    name = "Dan Peebles";
  };
  corngood = {
    email = "corngood@gmail.com";
    github = "corngood";
    githubId = 3077118;
    name = "David McFarland";
  };
  coroa = {
    email = "jonas@chaoflow.net";
    github = "coroa";
    githubId = 2552981;
    name = "Jonas Hörsch";
  };
  costrouc = {
    email = "chris.ostrouchov@gmail.com";
    github = "costrouc";
    githubId = 1740337;
    name = "Chris Ostrouchov";
  };
  confus = {
    email = "con-f-use@gmx.net";
    github = "con-f-use";
    githubId = 11145016;
    name = "J.C.";
  };
  congee = {
    email = "changshengwu@pm.me";
    matrix = "@congeec:matrix.org";
    github = "Congee";
    name = "Changsheng Wu";
    githubId = 2083950;
  };
  contrun = {
    email = "uuuuuu@protonmail.com";
    github = "contrun";
    githubId = 32609395;
    name = "B YI";
  };
  conradmearns = {
    email = "conradmearns+github@pm.me";
    github = "ConradMearns";
    githubId = 5510514;
    name = "Conrad Mearns";
  };
  corbanr = {
    email = "corban@raunco.co";
    github = "CorbanR";
    githubId = 1918683;
    matrix = "@corbansolo:matrix.org";
    name = "Corban Raun";
    keys = [
      {
        fingerprint = "6607 0B24 8CE5 64ED 22CE  0950 A697 A56F 1F15 1189";
      }
      {
        fingerprint = "D8CB 816A B678 A4E6 1EC7  5325 230F 4AC1 53F9 0F29";
      }
    ];
  };
  couchemar = {
    email = "couchemar@yandex.ru";
    github = "couchemar";
    githubId = 1573344;
    name = "Andrey Pavlov";
  };
  cpages = {
    email = "page@ruiec.cat";
    github = "cpages";
    githubId = 411324;
    name = "Carles Pagès";
  };
  cpu = {
    email = "daniel@binaryparadox.net";
    github = "cpu";
    githubId = 292650;
    name = "Daniel McCarney";
    keys = [{
      fingerprint = "8026 D24A A966 BF9C D3CD  CB3C 08FB 2BFC 470E 75B4";
    }];
  };
  Crafter = {
    email = "crafter@crafter.rocks";
    github = "Craftzman7";
    githubId = 70068692;
    name = "Crafter";
  };
  craigem = {
    email = "craige@mcwhirter.io";
    github = "craigem";
    githubId = 6470493;
    name = "Craige McWhirter";
  };
  cransom = {
    email = "cransom@hubns.net";
    github = "cransom";
    githubId = 1957293;
    name = "Casey Ransom";
  };
  CrazedProgrammer = {
    email = "crazedprogrammer@gmail.com";
    github = "CrazedProgrammer";
    githubId = 12202789;
    name = "CrazedProgrammer";
  };
  creator54 = {
    email = "hi.creator54@gmail.com";
    github = "Creator54";
    githubId = 34543609;
    name = "creator54";
  };
  crinklywrappr = {
    email = "crinklywrappr@pm.me";
    name = "Daniel Fitzpatrick";
    github = "crinklywrappr";
    githubId = 56522;
  };
  cript0nauta = {
    email = "shareman1204@gmail.com";
    github = "cript0nauta";
    githubId = 1222362;
    name = "Matías Lang";
  };
  CRTified = {
    email = "carl.schneider+nixos@rub.de";
    matrix = "@schnecfk:ruhr-uni-bochum.de";
    github = "CRTified";
    githubId = 2440581;
    name = "Carl Richard Theodor Schneider";
    keys = [{
      fingerprint = "2017 E152 BB81 5C16 955C  E612 45BC C1E2 709B 1788";
    }];
  };
  cryptix = {
    email = "cryptix@riseup.net";
    github = "cryptix";
    githubId = 111202;
    name = "Henry Bubert";
  };
  CrystalGamma = {
    email = "nixos@crystalgamma.de";
    github = "CrystalGamma";
    githubId = 6297001;
    name = "Jona Stubbe";
  };
  csingley = {
    email = "csingley@gmail.com";
    github = "csingley";
    githubId = 398996;
    name = "Christopher Singley";
  };
  cstrahan = {
    email = "charles@cstrahan.com";
    github = "cstrahan";
    githubId = 143982;
    name = "Charles Strahan";
  };
  cswank = {
    email = "craigswank@gmail.com";
    github = "cswank";
    githubId = 490965;
    name = "Craig Swank";
  };
  cust0dian = {
    email = "serg@effectful.software";
    github = "cust0dian";
    githubId = 389387;
    name = "Serg Nesterov";
    keys = [{
      fingerprint = "6E7D BA30 DB5D BA60 693C  3BE3 1512 F6EB 84AE CC8C";
    }];
  };
  cwoac = {
    email = "oliver@codersoffortune.net";
    github = "cwoac";
    githubId = 1382175;
    name = "Oliver Matthews";
  };
  cwyc = {
    email = "hello@cwyc.page";
    github = "cwyc";
    githubId = 16950437;
    name = "cwyc";
  };
  cynerd = {
    name = "Karel Kočí";
    email = "cynerd@email.cz";
    github = "Cynerd";
    githubId = 3811900;
    keys = [{
      fingerprint = "2B1F 70F9 5F1B 48DA 2265 A7FA A6BC 8B8C EB31 659B";
    }];
  };
  cyounkins = {
    name = "Craig Younkins";
    email = "cyounkins@gmail.com";
    github = "cyounkins";
    githubId = 346185;
  };
  cypherpunk2140 = {
    email = "stefan.mihaila@pm.me";
    github = "stefan-mihaila";
    githubId = 2217136;
    name = "Ștefan D. Mihăilă";
    keys = [
      {
        fingerprint = "CBC9 C7CC 51F0 4A61 3901 C723 6E68 A39B F16A 3ECB";
      }
      {
        fingerprint = "7EAB 1447 5BBA 7DDE 7092 7276 6220 AD78 4622 0A52";
      }
    ];
  };
  cyplo = {
    email = "nixos@cyplo.dev";
    matrix = "@cyplo:cyplo.dev";
    github = "cyplo";
    githubId = 217899;
    name = "Cyryl Płotnicki";
  };
  d-goldin = {
    email = "dgoldin+github@protonmail.ch";
    github = "d-goldin";
    githubId = 43349662;
    name = "Dima";
    keys = [{
      fingerprint = "1C4E F4FE 7F8E D8B7 1E88 CCDF BAB1 D15F B7B4 D4CE";
    }];
  };
  d-xo = {
    email = "hi@d-xo.org";
    github = "d-xo";
    githubId = 6689924;
    name = "David Terry";
  };
  dadada = {
    name = "dadada";
    email = "dadada@dadada.li";
    github = "dadada";
    githubId = 7216772;
    keys = [{
      fingerprint = "D68C 8469 5C08 7E0F 733A  28D0 EEB8 D1CE 62C4 DFEA";
    }];
  };
  dalance = {
    email = "dalance@gmail.com";
    github = "dalance";
    githubId = 4331004;
    name = "Naoya Hatta";
  };
  dalpd = {
    email = "denizalpd@ogr.iu.edu.tr";
    github = "dalpd";
    githubId = 16895361;
    name = "Deniz Alp Durmaz";
  };
  DAlperin = {
    email = "git@dov.dev";
    github = "DAlperin";
    githubId = 16063713;
    name = "Dov Alperin";
    keys = [{
      fingerprint = "4EED 5096 B925 86FA 1101  6673 7F2C 07B9 1B52 BB61";
    }];
  };
  DamienCassou = {
    email = "damien@cassou.me";
    github = "DamienCassou";
    githubId = 217543;
    name = "Damien Cassou";
  };
  danbst = {
    email = "abcz2.uprola@gmail.com";
    github = "danbst";
    githubId = 743057;
    name = "Danylo Hlynskyi";
  };
  danc86 = {
    name = "Dan Callaghan";
    email = "djc@djc.id.au";
    github = "danc86";
    githubId = 398575;
    keys = [{
      fingerprint = "1C56 01F1 D70A B56F EABB  6BC0 26B5 AA2F DAF2 F30A";
    }];
  };
  dancek = {
    email = "hannu.hartikainen@gmail.com";
    github = "dancek";
    githubId = 245394;
    name = "Hannu Hartikainen";
  };
  danderson = {
    email = "dave@natulte.net";
    github = "danderson";
    githubId = 1918;
    name = "David Anderson";
  };
  dandellion = {
    email = "daniel@dodsorf.as";
    matrix = "@dandellion:dodsorf.as";
    github = "dali99";
    githubId = 990767;
    name = "Daniel Olsen";
  };
  daneads = {
    email = "me@daneads.com";
    github = "daneads";
    githubId = 24708079;
    name = "Dan Eads";
  };
  danielbarter = {
    email = "danielbarter@gmail.com";
    github = "danielbarter";
    githubId = 8081722;
    name = "Daniel Barter";
  };
  danieldk = {
    email = "me@danieldk.eu";
    github = "danieldk";
    githubId = 49398;
    name = "Daniël de Kok";
  };
  danielfullmer = {
    email = "danielrf12@gmail.com";
    github = "danielfullmer";
    githubId = 1298344;
    name = "Daniel Fullmer";
  };
  danth = {
    name = "Daniel Thwaites";
    email = "danthwaites30@btinternet.com";
    matrix = "@danth:danth.me";
    github = "danth";
    githubId = 28959268;
    keys = [{
      fingerprint = "4779 D1D5 3C97 2EAE 34A5  ED3D D8AF C4BF 0567 0F9D";
    }];
  };
  dan4ik605743 = {
    email = "6057430gu@gmail.com";
    github = "dan4ik605743";
    githubId = 86075850;
    name = "Danil Danevich";
  };
  darkonion0 = {
    name = "Alexandre Peruggia";
    email = "darkgenius1@protonmail.com";
    matrix = "@alexoo:matrix.org";
    github = "DarkOnion0";
    githubId = 68606322;
  };
  das-g = {
    email = "nixpkgs@raphael.dasgupta.ch";
    github = "das-g";
    githubId = 97746;
    name = "Raphael Das Gupta";
  };
  das_j = {
    email = "janne@hess.ooo";
    matrix = "@janne.hess:helsinki-systems.de";
    github = "dasJ";
    githubId = 4971975;
    name = "Janne Heß";
  };
  dasisdormax = {
    email = "dasisdormax@mailbox.org";
    github = "dasisdormax";
    githubId = 3714905;
    keys = [{
      fingerprint = "E59B A198 61B0 A9ED C1FA  3FB2 02BA 0D44 80CA 6C44";
    }];
    name = "Maximilian Wende";
  };
  dasj19 = {
    email = "daniel@serbanescu.dk";
    github = "dasj19";
    githubId = 7589338;
    name = "Daniel Șerbănescu";
  };
  datafoo = {
    email = "34766150+datafoo@users.noreply.github.com";
    github = "datafoo";
    githubId = 34766150;
    name = "datafoo";
  };
  davhau = {
    email = "d.hauer.it@gmail.com";
    name = "David Hauer";
    github = "DavHau";
    githubId = 42246742;
  };
  david-sawatzke = {
    email = "d-nix@sawatzke.dev";
    github = "david-sawatzke";
    githubId = 11035569;
    name = "David Sawatzke";
  };
  david50407 = {
    email = "me@davy.tw";
    github = "david50407";
    githubId = 841969;
    name = "David Kuo";
  };
  davidak = {
    email = "post@davidak.de";
    matrix = "@davidak:matrix.org";
    github = "davidak";
    githubId = 91113;
    name = "David Kleuker";
  };
  davidarmstronglewis = {
    email = "davidlewis@mac.com";
    github = "davidarmstronglewis";
    githubId = 6754950;
    name = "David Armstrong Lewis";
  };
  davidrusu = {
    email = "davidrusu.me@gmail.com";
    github = "davidrusu";
    githubId = 1832378;
    name = "David Rusu";
  };
  davidtwco = {
    email = "david@davidtw.co";
    github = "davidtwco";
    githubId = 1295100;
    name = "David Wood";
    keys = [{
      fingerprint = "5B08 313C 6853 E5BF FA91  A817 0176 0B4F 9F53 F154";
    }];
  };
  davorb = {
    email = "davor@davor.se";
    github = "davorb";
    githubId = 798427;
    name = "Davor Babic";
  };
  davsanchez = {
    email = "davidslt+nixpkgs@pm.me";
    github = "davsanchez";
    githubId = 11422515;
    name = "David Sánchez";
  };
  dawidsowa = {
    email = "dawid_sowa@posteo.net";
    github = "dawidsowa";
    githubId = 49904992;
    name = "Dawid Sowa";
  };
  dbeckwith = {
    email = "djbsnx@gmail.com";
    github = "dbeckwith";
    githubId = 1279939;
    name = "Daniel Beckwith";
  };
  dbirks = {
    email = "david@birks.dev";
    github = "dbirks";
    githubId = 7545665;
    name = "David Birks";
    keys = [{
      fingerprint = "B26F 9AD8 DA20 3392 EF87  C61A BB99 9F83 D9A1 9A36";
    }];
  };
  dbohdan = {
    email = "dbohdan@dbohdan.com";
    github = "dbohdan";
    githubId = 3179832;
    name = "D. Bohdan";
  };
  dbrock = {
    email = "daniel@brockman.se";
    github = "dbrock";
    githubId = 14032;
    name = "Daniel Brockman";
  };
  ddelabru = {
    email = "ddelabru@redhat.com";
    github = "ddelabru";
    githubId = 39909293;
    name = "Dominic Delabruere";
  };
  dduan = {
    email = "daniel@duan.ca";
    github = "dduan";
    githubId = 75067;
    name = "Daniel Duan";
  };
  dearrude = {
    name = "Ebrahim Nejati";
    email = "dearrude@tfwno.gf";
    github = "DearRude";
    githubId = 30749142;
    keys = [{
      fingerprint = "4E35 F2E5 2132 D654 E815  A672 DB2C BC24 2868 6000";
    }];
  };
  deejayem = {
    email = "nixpkgs.bu5hq@simplelogin.com";
    github = "deejayem";
    githubId = 2564003;
    name = "David Morgan";
    keys = [{
      fingerprint = "9B43 6B14 77A8 79C2 6CDB  6604 C171 2510 02C2 00F2";
    }];
  };
  deepfire = {
    email = "_deepfire@feelingofgreen.ru";
    github = "deepfire";
    githubId = 452652;
    name = "Kosyrev Serge";
  };
  DeeUnderscore = {
    email = "d.anzorge@gmail.com";
    github = "DeeUnderscore";
    githubId = 156239;
    name = "D Anzorge";
  };
  delan = {
    name = "Delan Azabani";
    email = "delan@azabani.com";
    github = "delan";
    githubId = 465303;
  };
  delehef = {
    name = "Franklin Delehelle";
    email = "nix@odena.eu";
    github = "delehef";
    githubId = 1153808;
  };
  deliciouslytyped = {
    email = "47436522+deliciouslytyped@users.noreply.github.com";
    github = "deliciouslytyped";
    githubId = 47436522;
    name = "deliciouslytyped";
  };
  delroth = {
    email = "delroth@gmail.com";
    github = "delroth";
    githubId = 202798;
    name = "Pierre Bourdon";
  };
  delta = {
    email = "d4delta@outlook.fr";
    github = "D4Delta";
    githubId = 12224254;
    name = "Delta";
  };
  deltadelta = {
    email = "contact@libellules.eu";
    name = "Dara Ly";
    github = "tournemire";
    githubId = 20159432;
  };
  deltaevo = {
    email = "deltaduartedavid@gmail.com";
    github = "DeltaEvo";
    githubId = 8864716;
    name = "Duarte David";
  };
  demin-dmitriy = {
    email = "demindf@gmail.com";
    github = "demin-dmitriy";
    githubId = 5503422;
    name = "Dmitriy Demin";
  };
  demize = {
    email = "johannes@kyriasis.com";
    github = "kyrias";
    githubId = 2285387;
    name = "Johannes Löthberg";
  };
  demyanrogozhin = {
    email = "demyan.rogozhin@gmail.com";
    github = "demyanrogozhin";
    githubId = 62989;
    name = "Demyan Rogozhin";
  };
  derchris = {
    email = "derchris@me.com";
    github = "derchrisuk";
    githubId = 706758;
    name = "Christian Gerbrandt";
  };
  derekcollison = {
    email = "derek@nats.io";
    github = "derekcollison";
    githubId = 90097;
    name = "Derek Collison";
  };
  DerGuteMoritz = {
    email = "moritz@twoticketsplease.de";
    github = "DerGuteMoritz";
    githubId = 19733;
    name = "Moritz Heidkamp";
  };
  DerickEddington = {
    email = "derick.eddington@pm.me";
    github = "DerickEddington";
    githubId = 4731128;
    name = "Derick Eddington";
  };
  dermetfan = {
    email = "serverkorken@gmail.com";
    github = "dermetfan";
    githubId = 4956158;
    name = "Robin Stumm";
  };
  DerTim1 = {
    email = "tim.digel@active-group.de";
    github = "DerTim1";
    githubId = 21953890;
    name = "Tim Digel";
  };
  desiderius = {
    email = "didier@devroye.name";
    github = "desiderius";
    githubId = 1311761;
    name = "Didier J. Devroye";
  };
  desttinghim = {
    email = "opensource@louispearson.work";
    matrix = "@desttinghim:matrix.org";
    github = "desttinghim";
    githubId = 10042482;
    name = "Louis Pearson";
  };
  Dettorer = {
    name = "Paul Hervot";
    email = "paul.hervot@dettorer.net";
    matrix = "@dettorer:matrix.org";
    github = "Dettorer";
    githubId = 2761682;
  };
  devhell = {
    email = ''"^"@regexmail.net'';
    github = "devhell";
    githubId = 896182;
    name = "devhell";
  };
  devins2518 = {
    email = "drsingh2518@icloud.com";
    github = "devins2518";
    githubId = 17111639;
    name = "Devin Singh";
  };
  devusb = {
    email = "mhelton@devusb.us";
    github = "devusb";
    githubId = 4951663;
    name = "Morgan Helton";
  };
  dezgeg = {
    email = "tuomas.tynkkynen@iki.fi";
    github = "dezgeg";
    githubId = 579369;
    name = "Tuomas Tynkkynen";
  };
  dfordivam = {
    email = "dfordivam+nixpkgs@gmail.com";
    github = "dfordivam";
    githubId = 681060;
    name = "Divam";
  };
  dfoxfranke = {
    email = "dfoxfranke@gmail.com";
    github = "dfoxfranke";
    githubId = 4708206;
    name = "Daniel Fox Franke";
  };
  dgliwka = {
    email = "dawid.gliwka@gmail.com";
    github = "dgliwka";
    githubId = 33262214;
    name = "Dawid Gliwka";
  };
  dgonyeo = {
    email = "derek@gonyeo.com";
    github = "dgonyeo";
    githubId = 2439413;
    name = "Derek Gonyeo";
  };
  dguenther = {
    email = "dguenther9@gmail.com";
    github = "dguenther";
    githubId = 767083;
    name = "Derek Guenther";
  };
  dhkl = {
    email = "david@davidslab.com";
    github = "dhl";
    githubId = 265220;
    name = "David Leung";
  };
  DianaOlympos = {
    email = "DianaOlympos@noreply.github.com";
    github = "DianaOlympos";
    githubId = 15774340;
    name = "Thomas Depierre";
  };
  diegolelis = {
    email = "diego.o.lelis@gmail.com";
    github = "DiegoLelis";
    githubId = 8404455;
    name = "Diego Lelis";
  };
  DieracDelta = {
    email = "justin@restivo.me";
    github = "DieracDelta";
    githubId = 13730968;
    name = "Justin Restivo";
  };
  diffumist = {
    email = "git@diffumist.me";
    github = "Diffumist";
    githubId = 32810399;
    name = "Diffumist";
  };
  diogox = {
    name = "Diogo Xavier";
    email = "13244408+diogox@users.noreply.github.com";
    github = "diogox";
    githubId = 13244408;
  };
  dipinhora = {
    email = "dipinhora+github@gmail.com";
    github = "dipinhora";
    githubId = 11946442;
    name = "Dipin Hora";
  };
  dirkx = {
    email = "dirkx@webweaving.org";
    github = "dirkx";
    githubId = 392583;
    name = "Dirk-Willem van Gulik";
  };
  disassembler = {
    email = "disasm@gmail.com";
    github = "disassembler";
    githubId = 651205;
    name = "Samuel Leathers";
  };
  disserman = {
    email = "disserman@gmail.com";
    github = "divi255";
    githubId = 40633781;
    name = "Sergei S.";
  };
  dit7ya = {
    email = "7rat13@gmail.com";
    github = "dit7ya";
    githubId = 14034137;
    name = "Mostly Void";
  };
  dizfer = {
    email = "david@izquierdofernandez.com";
    github = "DIzFer";
    githubId = 8852888;
    name = "David Izquierdo";
  };
  djacu = {
    email = "daniel.n.baker@gmail.com";
    github = "djacu";
    githubId = 7043297;
    name = "Daniel Baker";
  };
  djanatyn = {
    email = "djanatyn@gmail.com";
    github = "djanatyn";
    githubId = 523628;
    name = "Jonathan Strickland";
  };
  Dje4321 = {
    email = "dje4321@gmail.com";
    github = "dje4321";
    githubId = 10913120;
    name = "Dje4321";
  };
  djwf = {
    email = "dave@weller-fahy.com";
    github = "djwf";
    githubId = 73162;
    name = "David J. Weller-Fahy";
  };
  dkabot = {
    email = "dkabot@dkabot.com";
    github = "dkabot";
    githubId = 1316469;
    name = "Naomi Morse";
  };
  dlesl = {
    email = "dlesl@dlesl.com";
    github = "dlesl";
    githubId = 28980797;
    name = "David Leslie";
  };
  dlip = {
    email = "dane@lipscombe.com.au";
    github = "dlip";
    githubId = 283316;
    name = "Dane Lipscombe";
  };
  dmalikov = {
    email = "malikov.d.y@gmail.com";
    github = "dmalikov";
    githubId = 997543;
    name = "Dmitry Malikov";
  };
  DmitryTsygankov = {
    email = "dmitry.tsygankov@gmail.com";
    github = "DmitryTsygankov";
    githubId = 425354;
    name = "Dmitry Tsygankov";
  };
  dmjio = {
    email = "djohnson.m@gmail.com";
    github = "dmjio";
    githubId = 875324;
    name = "David Johnson";
  };
  dmrauh = {
    email = "dmrauh@posteo.de";
    github = "dmrauh";
    githubId = 37698547;
    name = "Dominik Michael Rauh";
  };
  dmvianna = {
    email = "dmlvianna@gmail.com";
    github = "dmvianna";
    githubId = 1708810;
    name = "Daniel Vianna";
  };
  dnr = {
    email = "dnr@dnr.im";
    github = "dnr";
    githubId = 466723;
    name = "David Reiss";
  };
  dochang = {
    email = "dochang@gmail.com";
    github = "dochang";
    githubId = 129093;
    name = "Desmond O. Chang";
  };
  domenkozar = {
    email = "domen@dev.si";
    github = "domenkozar";
    githubId = 126339;
    name = "Domen Kozar";
  };
  DomesticMoth = {
    name = "Andrew";
    email = "silkmoth@protonmail.com";
    github = "DomesticMoth";
    githubId = 91414737;
    keys = [{
      fingerprint = "7D6B AE0A A98A FDE9 3396  E721 F87E 15B8 3AA7 3087";
    }];
  };
  dominikh = {
    email = "dominik@honnef.co";
    github = "dominikh";
    githubId = 39825;
    name = "Dominik Honnef";
  };
  doronbehar = {
    email = "me@doronbehar.com";
    github = "doronbehar";
    githubId = 10998835;
    name = "Doron Behar";
  };
  dotlambda = {
    email = "rschuetz17@gmail.com";
    matrix = "@robert:funklause.de";
    github = "dotlambda";
    githubId = 6806011;
    name = "Robert Schütz";
  };
  dottedmag = {
    email = "dottedmag@dottedmag.net";
    github = "dottedmag";
    githubId = 16120;
    name = "Misha Gusarov";
    keys = [{
      fingerprint = "A8DF 1326 9E5D 9A38 E57C  FAC2 9D20 F650 3E33 8888";
    }];
  };
  doublec = {
    email = "chris.double@double.co.nz";
    github = "doublec";
    githubId = 16599;
    name = "Chris Double";
  };
  dpaetzel = {
    email = "david.paetzel@posteo.de";
    github = "dpaetzel";
    githubId = 974130;
    name = "David Pätzel";
  };
  dpausp = {
    email = "dpausp@posteo.de";
    github = "dpausp";
    githubId = 1965950;
    name = "Tobias Stenzel";
    keys = [{
      fingerprint = "4749 0887 CF3B 85A1 6355  C671 78C7 DD40 DF23 FB16";
    }];
  };
  DPDmancul = {
    name = "Davide Peressoni";
    email = "davide.peressoni@tuta.io";
    matrix = "@dpd-:matrix.org";
    githubId = 3186857;
  };
  dpercy = {
    email = "dpercy@dpercy.dev";
    github = "dpercy";
    githubId = 349909;
    name = "David Percy";
  };
  dpflug = {
    email = "david@pflug.email";
    github = "dpflug";
    githubId = 108501;
    name = "David Pflug";
  };
  dramaturg = {
    email = "seb@ds.ag";
    github = "dramaturg";
    githubId = 472846;
    name = "Sebastian Krohn";
  };
  drets = {
    email = "dmitryrets@gmail.com";
    github = "drets";
    githubId = 6199462;
    name = "Dmytro Rets";
  };
  drewrisinger = {
    email = "drisinger+nixpkgs@gmail.com";
    github = "drewrisinger";
    githubId = 10198051;
    name = "Drew Risinger";
  };
  dritter = {
    email = "dritter03@googlemail.com";
    github = "dritter";
    githubId = 1544760;
    name = "Dominik Ritter";
  };
  drperceptron = {
    email = "92106371+drperceptron@users.noreply.github.com";
    github = "drperceptron";
    githubId = 92106371;
    name = "Dr Perceptron";
    keys = [{
      fingerprint = "7E38 89D9 B1A8 B381 C8DE  A15F 95EB 6DFF 26D1 CEB0";
    }];
  };
  drupol = {
    name = "Pol Dellaiera";
    email = "pol.dellaiera@protonmail.com";
    matrix = "@drupol:matrix.org";
    github = "drupol";
    githubId = 252042;
    keys = [{
      fingerprint = "85F3 72DF 4AF3 EF13 ED34  72A3 0AAF 2901 E804 0715";
    }];
  };
  drzoidberg = {
    email = "jakob@mast3rsoft.com";
    github = "jakobneufeld";
    githubId = 24791219;
    name = "Jakob Neufeld";
  };
  dsalaza4 = {
    email = "podany270895@gmail.com";
    github = "dsalaza4";
    githubId = 11205987;
    name = "Daniel Salazar";
  };
  dschrempf = {
    name = "Dominik Schrempf";
    email = "dominik.schrempf@gmail.com";
    github = "dschrempf";
    githubId = 5596239;
    keys = [{
      fingerprint = "62BC E2BD 49DF ECC7 35C7  E153 875F 2BCF 163F 1B29";
    }];
  };
  dsferruzza = {
    email = "david.sferruzza@gmail.com";
    github = "dsferruzza";
    githubId = 1931963;
    name = "David Sferruzza";
  };
  dtzWill = {
    email = "w@wdtz.org";
    github = "dtzWill";
    githubId = 817330;
    name = "Will Dietz";
    keys = [{
      fingerprint = "389A 78CB CD88 5E0C 4701  DEB9 FD42 C7D0 D414 94C8";
    }];
  };
  dukc = {
    email = "ajieskola@gmail.com";
    github = "dukc";
    githubId = 24233408;
    name = "Ate Eskola";
  };
  dump_stack = {
    email = "root@dumpstack.io";
    github = "jollheef";
    githubId = 1749762;
    name = "Mikhail Klementev";
    keys = [{
      fingerprint = "5DD7 C6F6 0630 F08E DAE7  4711 1525 585D 1B43 C62A";
    }];
  };
  dwarfmaster = {
    email = "nixpkgs@dwarfmaster.net";
    github = "dwarfmaster";
    githubId = 2025623;
    name = "Luc Chabassier";
  };
  dxf = {
    email = "dingxiangfei2009@gmail.com";
    github = "dingxiangfei2009";
    githubId = 6884440;
    name = "Ding Xiang Fei";
  };
  dysinger = {
    email = "tim@dysinger.net";
    github = "dysinger";
    githubId = 447;
    name = "Tim Dysinger";
  };
  dywedir = {
    email = "dywedir@gra.red";
    matrix = "@dywedir:matrix.org";
    github = "dywedir";
    githubId = 399312;
    name = "Vladyslav M.";
  };
  dzabraev = {
    email = "dzabraew@gmail.com";
    github = "dzabraev";
    githubId = 15128988;
    name = "Maksim Dzabraev";
  };
  e1mo = {
    email = "nixpkgs@e1mo.de";
    matrix = "@e1mo:chaos.jetzt";
    github = "e1mo";
    githubId = 61651268;
    name = "Moritz Fromm";
    keys = [{
      fingerprint = "67BE E563 43B6 420D 550E  DF2A 6D61 7FD0 A85B AADA";
    }];
  };
  eadwu = {
    email = "edmund.wu@protonmail.com";
    github = "eadwu";
    githubId = 22758444;
    name = "Edmund Wu";
  };
  ealasu = {
    email = "emanuel.alasu@gmail.com";
    github = "ealasu";
    githubId = 1362096;
    name = "Emanuel Alasu";
  };
  eamsden = {
    email = "edward@blackriversoft.com";
    github = "eamsden";
    githubId = 54573;
    name = "Edward Amsden";
  };
  earldouglas = {
    email = "james@earldouglas.com";
    github = "earldouglas";
    githubId = 424946;
    name = "James Earl Douglas";
  };
  erikarvstedt = {
    email = "erik.arvstedt@gmail.com";
    matrix = "@erikarvstedt:matrix.org";
    github = "erikarvstedt";
    githubId = 36110478;
    name = "Erik Arvstedt";
  };
  ebbertd = {
    email = "daniel@ebbert.nrw";
    github = "ebbertd";
    githubId = 20522234;
    name = "Daniel Ebbert";
    keys = [{
      fingerprint = "E765 FCA3 D9BF 7FDB 856E  AD73 47BC 1559 27CB B9C7";
    }];
  };
  ebzzry = {
    email = "ebzzry@ebzzry.io";
    github = "ebzzry";
    githubId = 7875;
    name = "Rommel Martinez";
  };
  edanaher = {
    email = "nixos@edanaher.net";
    github = "edanaher";
    githubId = 984691;
    name = "Evan Danaher";
  };
  edbentley = {
    email = "hello@edbentley.dev";
    github = "edbentley";
    githubId = 15923595;
    name = "Ed Bentley";
  };
  edcragg = {
    email = "ed.cragg@eipi.xyz";
    github = "nuxeh";
    githubId = 1516017;
    name = "Ed Cragg";
  };
  edef = {
    email = "edef@edef.eu";
    github = "edef1c";
    githubId = 50854;
    name = "edef";
  };
  edlimerkaj = {
    name = "Edli Merkaj";
    email = "edli.merkaj@identinet.io";
    github = "edlimerkaj";
    githubId = 71988351;
  };
  edrex = {
    email = "ericdrex@gmail.com";
    github = "edrex";
    githubId = 14615;
    keys = [{
      fingerprint = "AC47 2CCC 9867 4644 A9CF  EB28 1C5C 1ED0 9F66 6824";
    }];
    matrix = "@edrex:matrix.org";
    name = "Eric Drechsel";
  };
  ehllie = {
    email = "me@ehllie.xyz";
    github = "ehllie";
    githubId = 20847625;
    name = "Elizabeth Paź";
  };
  elliottslaughter = {
    name = "Elliott Slaughter";
    email = "elliottslaughter@gmail.com";
    github = "elliottslaughter";
    githubId = 3129;
  };
  emantor = {
    email = "rouven+nixos@czerwinskis.de";
    github = "Emantor";
    githubId = 934284;
    name = "Rouven Czerwinski";
  };
  embr = {
    email = "hi@liclac.eu";
    github = "liclac";
    githubId = 428026;
    name = "embr";
  };
  emily = {
    email = "nixpkgs@emily.moe";
    github = "emilazy";
    githubId = 18535642;
    name = "Emily";
  };
  emilytrau = {
    name = "Emily Trau";
    email = "nix@angus.ws";
    github = "emilytrau";
    githubId = 13267947;
  };
  enderger = {
    email = "endergeryt@gmail.com";
    github = "enderger";
    githubId = 36283171;
    name = "Daniel";
  };
  endocrimes = {
    email = "dani@builds.terrible.systems";
    github = "endocrimes";
    githubId = 1330683;
    name = "Danielle Lancashire";
  };
  ederoyd46 = {
    email = "matt@ederoyd.co.uk";
    github = "ederoyd46";
    githubId = 119483;
    name = "Matthew Brown";
  };
  eduarrrd = {
    email = "e.bachmakov@gmail.com";
    github = "eduarrrd";
    githubId = 1181393;
    name = "Eduard Bachmakov";
  };
  edude03 = {
    email = "michael@melenion.com";
    github = "edude03";
    githubId = 494483;
    name = "Michael Francis";
  };
  edwtjo = {
    email = "ed@cflags.cc";
    github = "edwtjo";
    githubId = 54799;
    name = "Edward Tjörnhammar";
  };
  eelco = {
    email = "edolstra+nixpkgs@gmail.com";
    github = "edolstra";
    githubId = 1148549;
    name = "Eelco Dolstra";
  };
  ehegnes = {
    email = "eric.hegnes@gmail.com";
    github = "ehegnes";
    githubId = 884970;
    name = "Eric Hegnes";
  };
  ehmry = {
    email = "ehmry@posteo.net";
    github = "ehmry";
    githubId = 537775;
    name = "Emery Hemingway";
  };
  eigengrau = {
    email = "seb@schattenkopie.de";
    name = "Sebastian Reuße";
    github = "eigengrau";
    githubId = 4939947;
  };
  eikek = {
    email = "eike.kettner@posteo.de";
    github = "eikek";
    githubId = 701128;
    name = "Eike Kettner";
  };
  ekleog = {
    email = "leo@gaspard.io";
    matrix = "@leo:gaspard.ninja";
    github = "Ekleog";
    githubId = 411447;
    name = "Leo Gaspard";
  };
  elasticdog = {
    email = "aaron@elasticdog.com";
    github = "elasticdog";
    githubId = 4742;
    name = "Aaron Bull Schaefer";
  };
  elatov = {
    email = "elatov@gmail.com";
    github = "elatov";
    githubId = 7494394;
    name = "Karim Elatov";
  };
  eleanor = {
    email = "dejan@proteansec.com";
    github = "proteansec";
    githubId = 1753498;
    name = "Dejan Lukan";
  };
  electrified = {
    email = "ed@maidavale.org";
    github = "electrified";
    githubId = 103082;
    name = "Ed Brindley";
  };
  elizagamedev = {
    email = "eliza@eliza.sh";
    github = "elizagamedev";
    githubId = 4576666;
    name = "Eliza Velasquez";
  };
  elliot = {
    email = "hack00mind@gmail.com";
    github = "Eliot00";
    githubId = 18375468;
    name = "Elliot Xu";
  };
  elliottvillars = {
    email = "elliottvillars@gmail.com";
    github = "elliottvillars";
    githubId = 48104179;
    name = "Elliott Villars";
  };
  eliasp = {
    email = "mail@eliasprobst.eu";
    matrix = "@eliasp:kde.org";
    github = "eliasp";
    githubId = 48491;
    name = "Elias Probst";
  };
  elijahcaine = {
    email = "elijahcainemv@gmail.com";
    github = "pop";
    githubId = 1897147;
    name = "Elijah Caine";
  };
  Elinvention = {
    email = "elia@elinvention.ovh";
    github = "Elinvention";
    githubId = 5737945;
    name = "Elia Argentieri";
  };
  elitak = {
    email = "elitak@gmail.com";
    github = "elitak";
    githubId = 769073;
    name = "Eric Litak";
  };
  ellis = {
    email = "nixos@ellisw.net";
    github = "ellis";
    githubId = 97852;
    name = "Ellis Whitehead";
  };
  elkowar = {
    email = "thereal.elkowar@gmail.com";
    github = "elkowar";
    githubId = 5300871;
    name = "Leon Kowarschick";
  };
  elnudev = {
    email = "elnu@elnu.com";
    github = "elnudev";
    githubId = 9874955;
    name = "Elnu";
  };
  elohmeier = {
    email = "elo-nixos@nerdworks.de";
    github = "elohmeier";
    githubId = 2536303;
    name = "Enno Lohmeier";
  };
  elvishjerricco = {
    email = "elvishjerricco@gmail.com";
    github = "ElvishJerricco";
    githubId = 1365692;
    name = "Will Fancher";
  };
  emattiza = {
    email = "nix@mattiza.dev";
    github = "emattiza";
    githubId = 11719476;
    name = "Evan Mattiza";
  };
  emmabastas = {
    email = "emma.bastas@protonmail.com";
    matrix = "@emmabastas:matrix.org";
    github = "emmabastas";
    githubId = 22533224;
    name = "Emma Bastås";
  };
  emmanuelrosa = {
    email = "emmanuelrosa@protonmail.com";
    matrix = "@emmanuelrosa:matrix.org";
    github = "emmanuelrosa";
    githubId = 13485450;
    name = "Emmanuel Rosa";
  };
  emptyflask = {
    email = "jon@emptyflask.dev";
    github = "emptyflask";
    githubId = 28287;
    name = "Jon Roberts";
  };
  endgame = {
    email = "jack@jackkelly.name";
    github = "endgame";
    githubId = 231483;
    name = "Jack Kelly";
  };
  enorris = {
    name = "Eric Norris";
    email = "erictnorris@gmail.com";
    github = "ericnorris";
    githubId = 1906605;
  };
  Enteee = {
    email = "nix@duckpond.ch";
    github = "Enteee";
    githubId = 5493775;
    name = "Ente";
  };
  Enzime = {
    email = "enzime@users.noreply.github.com";
    github = "Enzime";
    githubId = 10492681;
    name = "Michael Hoang";
  };
  eonpatapon = {
    email = "eon@patapon.info";
    github = "eonpatapon";
    githubId = 418227;
    name = "Jean-Philippe Braun";
  };
  eperuffo = {
    email = "info@emanueleperuffo.com";
    github = "emanueleperuffo";
    githubId = 5085029;
    name = "Emanuele Peruffo";
  };
  equirosa = {
    email = "eduardo@eduardoquiros.com";
    github = "equirosa";
    githubId = 39096810;
    name = "Eduardo Quiros";
  };
  eqyiel = {
    email = "ruben@maher.fyi";
    github = "eqyiel";
    githubId = 3422442;
    name = "Ruben Maher";
  };
  eraserhd = {
    email = "jason.m.felice@gmail.com";
    github = "eraserhd";
    githubId = 147284;
    name = "Jason Felice";
  };
  ercao = {
    email = "vip@ercao.cn";
    github = "ercao";
    githubId = 51725284;
    name = "ercao";
    keys = [{
      fingerprint = "F3B0 36F7 B0CB 0964 3C12  D3C7 FFAB D125 7ECF 0889";
    }];
  };
  erdnaxe = {
    email = "erdnaxe@crans.org";
    github = "erdnaxe";
    githubId = 2663216;
    name = "Alexandre Iooss";
    keys = [{
      fingerprint = "2D37 1AD2 7E2B BC77 97E1  B759 6C79 278F 3FCD CC02";
    }];
  };
  ereslibre = {
    email = "ereslibre@ereslibre.es";
    matrix = "@ereslibre:matrix.org";
    github = "ereslibre";
    githubId = 8706;
    name = "Rafael Fernández López";
  };
  ericbmerritt = {
    email = "eric@afiniate.com";
    github = "ericbmerritt";
    githubId = 4828;
    name = "Eric Merritt";
  };
  ericdallo = {
    email = "ercdll1337@gmail.com";
    github = "ericdallo";
    githubId = 7820865;
    name = "Eric Dallo";
  };
  ericsagnes = {
    email = "eric.sagnes@gmail.com";
    github = "ericsagnes";
    githubId = 367880;
    name = "Eric Sagnes";
  };
  ericson2314 = {
    email = "John.Ericson@Obsidian.Systems";
    matrix = "@ericson2314:matrix.org";
    github = "Ericson2314";
    githubId = 1055245;
    name = "John Ericson";
  };
  erictapen = {
    email = "kerstin@erictapen.name";
    github = "erictapen";
    githubId = 11532355;
    name = "Kerstin Humm";
    keys = [{
      fingerprint = "F178 B4B4 6165 6D1B 7C15  B55D 4029 3358 C7B9 326B";
    }];
  };
  erikbackman = {
    email = "contact@ebackman.net";
    github = "erikbackman";
    githubId = 46724898;
    name = "Erik Backman";
  };
  erikryb = {
    email = "erik.rybakken@math.ntnu.no";
    github = "erikryb";
    githubId = 3787281;
    name = "Erik Rybakken";
  };
  erin = {
    name = "Erin van der Veen";
    email = "erin@erinvanderveen.nl";
    github = "ErinvanderVeen";
    githubId = 10973664;
  };
  erosennin = {
    email = "ag@sologoc.com";
    github = "erosennin";
    githubId = 1583484;
    name = "Andrey Golovizin";
  };
  ersin = {
    email = "me@ersinakinci.com";
    github = "ersinakinci";
    githubId = 5427394;
    name = "Ersin Akinci";
  };
  ertes = {
    email = "esz@posteo.de";
    github = "ertes";
    githubId = 1855930;
    name = "Ertugrul Söylemez";
  };
  esclear = {
    email = "esclear@users.noreply.github.com";
    github = "esclear";
    githubId = 7432848;
    name = "Daniel Albert";
  };
  eskytthe = {
    email = "eskytthe@gmail.com";
    github = "eskytthe";
    githubId = 2544204;
    name = "Erik Skytthe";
  };
  ethancedwards8 = {
    email = "ethan@ethancedwards.com";
    github = "ethancedwards8";
    githubId = 60861925;
    name = "Ethan Carter Edwards";
    keys = [{
      fingerprint = "0E69 0F46 3457 D812 3387  C978 F93D DAFA 26EF 2458";
    }];
  };
  ethercrow = {
    email = "ethercrow@gmail.com";
    github = "ethercrow";
    githubId = 222467;
    name = "Dmitry Ivanov";
  };
  ethindp = {
    name = "Ethin Probst";
    email = "harlydavidsen@gmail.com";
    matrix = "@ethindp:the-gdn.net";
    github = "ethindp";
    githubId = 8030501;
  };
  Etjean = {
    email = "et.jean@outlook.fr";
    github = "Etjean";
    githubId = 32169529;
    name = "Etienne Jean";
  };
  etu = {
    email = "elis@hirwing.se";
    matrix = "@etu:semi.social";
    github = "etu";
    githubId = 461970;
    name = "Elis Hirwing";
    keys = [{
      fingerprint = "67FE 98F2 8C44 CF22 1828  E12F D57E FA62 5C9A 925F";
    }];
  };
  euank = {
    email = "euank-nixpkg@euank.com";
    github = "euank";
    githubId = 2147649;
    name = "Euan Kemp";
  };
  evalexpr = {
    name = "Jonathan Wilkins";
    email = "nixos@wilkins.tech";
    matrix = "@evalexpr:matrix.org";
    github = "evalexpr";
    githubId = 23485511;
    keys = [{
      fingerprint = "8129 5B85 9C5A F703 C2F4  1E29 2D1D 402E 1776 3DD6";
    }];
  };
  evanjs = {
    email = "evanjsx@gmail.com";
    github = "evanjs";
    githubId = 1847524;
    name = "Evan Stoll";
  };
  evax = {
    email = "nixos@evax.fr";
    github = "evax";
    githubId = 599997;
    name = "evax";
  };
  evck = {
    email = "eric@evenchick.com";
    github = "ericevenchick";
    githubId = 195032;
    name = "Eric Evenchick";
  };
  evenbrenden = {
    email = "evenbrenden@gmail.com";
    github = "evenbrenden";
    githubId = 2512008;
    name = "Even Brenden";
  };
  evils = {
    email = "evils.devils@protonmail.com";
    matrix = "@evils:nixos.dev";
    github = "evils";
    githubId = 30512529;
    name = "Evils";
  };
  ewok = {
    email = "ewok@ewok.ru";
    github = "ewok";
    githubId = 454695;
    name = "Artur Taranchiev";
  };
  exarkun = {
    email = "exarkun@twistedmatrix.com";
    github = "exarkun";
    githubId = 254565;
    name = "Jean-Paul Calderone";
  };
  exfalso = {
    email = "0slemi0@gmail.com";
    github = "exFalso";
    githubId = 1042674;
    name = "Andras Slemmer";
  };
  exi = {
    email = "nixos@reckling.org";
    github = "exi";
    githubId = 449463;
    name = "Reno Reckling";
  };
  exlevan = {
    email = "exlevan@gmail.com";
    github = "exlevan";
    githubId = 873530;
    name = "Alexey Levan";
  };
  expipiplus1 = {
    email = "nix@monoid.al";
    matrix = "@ellie:monoid.al";
    github = "expipiplus1";
    githubId = 857308;
    name = "Ellie Hermaszewska";
    keys = [{
      fingerprint = "FC1D 3E4F CBCA 80DF E870  6397 C811 6E3A 0C1C A76A";
    }];
  };
  extends = {
    email = "sharosari@gmail.com";
    github = "ImExtends";
    githubId = 55919390;
    name = "Vincent VILLIAUMEY";
  };
  eyjhb = {
    email = "eyjhbb@gmail.com";
    matrix = "@eyjhb:eyjhb.dk";
    github = "eyJhb";
    githubId = 25955146;
    name = "eyJhb";
  };
  f--t = {
    email = "git@f-t.me";
    github = "f--t";
    githubId = 2817965;
    name = "f--t";
  };
  f4814n = {
    email = "me@f4814n.de";
    github = "f4814";
    githubId = 11909469;
    name = "Fabian Geiselhart";
  };
  fab = {
    email = "mail@fabian-affolter.ch";
    matrix = "@fabaff:matrix.org";
    name = "Fabian Affolter";
    github = "fabaff";
    githubId = 116184;
    keys = [{
      fingerprint = "2F6C 930F D3C4 7E38 6AFA  4EB4 E23C D2DD 36A4 397F";
    }];
  };
  fabiangd = {
    email = "fabian.g.droege@gmail.com";
    name = "Fabian G. Dröge";
    github = "FabianGD";
    githubId = 40316600;
  };
  fabianhauser = {
    email = "fabian.nixos@fh2.ch";
    github = "fabianhauser";
    githubId = 368799;
    name = "Fabian Hauser";
    keys = [{
      fingerprint = "50B7 11F4 3DFD 2018 DCE6  E8D0 8A52 A140 BEBF 7D2C";
    }];
  };
  fabianhjr = {
    email = "fabianhjr@protonmail.com";
    github = "fabianhjr";
    githubId = 303897;
    name = "Fabián Heredia Montiel";
  };
  fadenb = {
    email = "tristan.helmich+nixos@gmail.com";
    github = "fadenb";
    githubId = 878822;
    name = "Tristan Helmich";
  };
  falsifian = {
    email = "james.cook@utoronto.ca";
    github = "falsifian";
    githubId = 225893;
    name = "James Cook";
  };
  farcaller = {
    name = "Vladimir Pouzanov";
    email = "farcaller@gmail.com";
    github = "farcaller";
    githubId = 693;
  };
  fare = {
    email = "fahree@gmail.com";
    github = "fare";
    githubId = 8073;
    name = "Francois-Rene Rideau";
  };
  farlion = {
    email = "florian.peter@gmx.at";
    github = "workflow";
    githubId = 1276854;
    name = "Florian Peter";
  };
  farnoy = {
    email = "jakub@okonski.org";
    github = "farnoy";
    githubId = 345808;
    name = "Jakub Okoński";
  };
  fbeffa = {
    email = "beffa@fbengineering.ch";
    github = "fedeinthemix";
    githubId = 7670450;
    name = "Federico Beffa";
  };
  fbergroth = {
    email = "fbergroth@gmail.com";
    github = "fbergroth";
    githubId = 1211003;
    name = "Fredrik Bergroth";
  };
  fbrs = {
    email = "yuuki@protonmail.com";
    github = "cideM";
    githubId = 4246921;
    name = "Florian Beeres";
  };
  fdns = {
    email = "fdns02@gmail.com";
    github = "fdns";
    githubId = 541748;
    name = "Felipe Espinoza";
  };
  federicoschonborn = {
    name = "Federico Damián Schonborn";
    email = "fdschonborn@gmail.com";
    github = "FedericoSchonborn";
    githubId = 62166915;
    matrix = "@FedericoDSchonborn:matrix.org";
    keys = [
      { fingerprint = "517A 8A6A 09CA A11C 9667  CEE3 193F 70F1 5C9A B0A0"; }
    ];
  };
  fedx-sudo = {
    email = "fedx-sudo@pm.me";
    github = "FedX-sudo";
    githubId = 66258975;
    name = "Fedx sudo";
    matrix = "fedx:matrix.org";
  };
  fee1-dead = {
    email = "ent3rm4n@gmail.com";
    github = "fee1-dead";
    githubId = 43851243;
    name = "Deadbeef";
  };
  fehnomenal = {
    email = "fehnomenal@fehn.systems";
    github = "fehnomenal";
    githubId = 9959940;
    name = "Andreas Fehn";
  };
  felipeqq2 = {
    name = "Felipe Silva";
    email = "nixpkgs@felipeqq2.rocks";
    github = "felipeqq2";
    githubId = 71830138;
    keys = [{ fingerprint = "F5F0 2BCE 3580 BF2B 707A  AA8C 2FD3 4A9E 2671 91B8"; }];
    matrix = "@felipeqq2:pub.solar";
  };
  felixscheinost = {
    name = "Felix Scheinost";
    email = "felix.scheinost@posteo.de";
    github = "felixscheinost";
    githubId = 31761492;
  };
  felixsinger = {
    email = "felixsinger@posteo.net";
    github = "felixsinger";
    githubId = 628359;
    name = "Felix Singer";
  };
  felschr = {
    email = "dev@felschr.com";
    matrix = "@felschr:matrix.org";
    github = "felschr";
    githubId = 3314323;
    name = "Felix Schröter";
    keys = [
      {
        # historical
        fingerprint = "6AB3 7A28 5420 9A41 82D9  0068 910A CB9F 6BD2 6F58";
      }
      {
        fingerprint = "7E08 6842 0934 AA1D 6821  1F2A 671E 39E6 744C 807D";
      }
    ];
  };
  ffinkdevs = {
    email = "fink@h0st.space";
    github = "ffinkdevs";
    githubId = 45924649;
    name = "Fabian Fink";
  };
  fgaz = {
    email = "fgaz@fgaz.me";
    matrix = "@fgaz:matrix.org";
    github = "fgaz";
    githubId = 8182846;
    name = "Francesco Gazzetta";
  };
  figsoda = {
    email = "figsoda@pm.me";
    matrix = "@figsoda:matrix.org";
    github = "figsoda";
    githubId = 40620903;
    name = "figsoda";
  };
  fionera = {
    email = "nix@fionera.de";
    github = "fionera";
    githubId = 5741401;
    name = "Tim Windelschmidt";
  };
  FireyFly = {
    email = "nix@firefly.nu";
    github = "FireyFly";
    githubId = 415760;
    name = "Jonas Höglund";
  };
  firefly-cpp = {
    email = "iztok@iztok-jr-fister.eu";
    github = "firefly-cpp";
    githubId = 1633361;
    name = "Iztok Fister Jr.";
  };
  fishi0x01 = {
    email = "fishi0x01@gmail.com";
    github = "fishi0x01";
    githubId = 10799507;
    name = "Karl Fischer";
  };
  fitzgibbon = {
    name = "Niall FitzGibbon";
    email = "fitzgibbon.niall@gmail.com";
    github = "fitzgibbon";
    githubId = 617048;
  };
  fkautz = {
    name = "Frederick F. Kautz IV";
    email = "fkautz@alumni.cmu.edu";
    github = "fkautz";
    githubId = 135706;
  };
  Flakebi = {
    email = "flakebi@t-online.de";
    github = "Flakebi";
    githubId = 6499211;
    name = "Sebastian Neubauer";
    keys = [{
      fingerprint = "2F93 661D AC17 EA98 A104  F780 ECC7 55EE 583C 1672";
    }];
  };
  fleaz = {
    email = "mail@felixbreidenstein.de";
    matrix = "@fleaz:rainbownerds.de";
    github = "fleaz";
    githubId = 2489598;
    name = "Felix Breidenstein";
  };
  flexagoon = {
    email = "flexagoon@pm.me";
    github = "flexagoon";
    githubId = 66178592;
    name = "Pavel Zolotarevskiy";
  };
  fliegendewurst = {
    email = "arne.keller@posteo.de";
    github = "FliegendeWurst";
    githubId = 12560461;
    name = "Arne Keller";
  };
  flokli = {
    email = "flokli@flokli.de";
    github = "flokli";
    githubId = 183879;
    name = "Florian Klink";
  };
  florentc = {
    email = "florentc@users.noreply.github.com";
    github = "florentc";
    githubId = 1149048;
    name = "Florent Ch.";
  };
  FlorianFranzen = {
    email = "Florian.Franzen@gmail.com";
    github = "FlorianFranzen";
    githubId = 781077;
    name = "Florian Franzen";
  };
  florianjacob = {
    email = "projects+nixos@florianjacob.de";
    github = "florianjacob";
    githubId = 1109959;
    name = "Florian Jacob";
  };
  flosse = {
    email = "mail@markus-kohlhase.de";
    github = "flosse";
    githubId = 276043;
    name = "Markus Kohlhase";
  };
  fluffynukeit = {
    email = "dan@fluffynukeit.com";
    github = "fluffynukeit";
    githubId = 844574;
    name = "Daniel Austin";
  };
  flyfloh = {
    email = "nix@halbmastwurf.de";
    github = "flyfloh";
    githubId = 74379;
    name = "Florian Pester";
  };
  fmoda3 = {
    email = "fmoda3@mac.com";
    github = "fmoda3";
    githubId = 1746471;
    name = "Frank Moda III";
  };
  fmthoma = {
    email = "f.m.thoma@googlemail.com";
    github = "fmthoma";
    githubId = 5918766;
    name = "Franz Thoma";
  };
  fooker = {
    email = "fooker@lab.sh";
    github = "fooker";
    githubId = 405105;
    name = "Dustin Frisch";
  };
  foo-dogsquared = {
    email = "foo.dogsquared@gmail.com";
    github = "foo-dogsquared";
    githubId = 34962634;
    name = "Gabriel Arazas";
  };
  foolnotion = {
    email = "bogdan.burlacu@pm.me";
    github = "foolnotion";
    githubId = 844222;
    name = "Bogdan Burlacu";
    keys = [{
      fingerprint = "B722 6464 838F 8BDB 2BEA  C8C8 5B0E FDDF BA81 6105";
    }];
  };
  forkk = {
    email = "forkk@forkk.net";
    github = "Forkk";
    githubId = 1300078;
    name = "Andrew Okin";
  };
  fornever = {
    email = "friedrich@fornever.me";
    github = "ForNeVeR";
    githubId = 92793;
    name = "Friedrich von Never";
  };
  fortuneteller2k = {
    email = "lythe1107@gmail.com";
    matrix = "@fortuneteller2k:matrix.org";
    github = "fortuneteller2k";
    githubId = 20619776;
    name = "fortuneteller2k";
  };
  fpletz = {
    email = "fpletz@fnordicwalking.de";
    github = "fpletz";
    githubId = 114159;
    name = "Franz Pletz";
    keys = [{
      fingerprint = "8A39 615D CE78 AF08 2E23  F303 846F DED7 7926 17B4";
    }];
  };
  fps = {
    email = "mista.tapas@gmx.net";
    github = "fps";
    githubId = 84968;
    name = "Florian Paul Schmidt";
  };

  fragamus = {
    email = "innovative.engineer@gmail.com";
    github = "fragamus";
    githubId = 119691;
    name = "Michael Gough";
  };
  freax13 = {
    email = "erbse.13@gmx.de";
    github = "Freax13";
    githubId = 14952658;
    name = "Tom Dohrmann";
  };
  fredeb = {
    email = "im@fredeb.dev";
    github = "FredeEB";
    githubId = 7551358;
    name = "Frede Emil";
  };
  freezeboy = {
    email = "freezeboy@users.noreply.github.com";
    github = "freezeboy";
    githubId = 13279982;
    name = "freezeboy";
  };
  Fresheyeball = {
    email = "fresheyeball@gmail.com";
    github = "Fresheyeball";
    githubId = 609279;
    name = "Isaac Shapira";
  };
  fridh = {
    email = "fridh@fridh.nl";
    github = "FRidh";
    githubId = 2129135;
    name = "Frederik Rietdijk";
  };
  friedelino = {
    email = "friede.mann@posteo.de";
    github = "friedelino";
    githubId = 46672819;
    name = "Frido Friedemann";
  };
  frlan = {
    email = "frank@frank.uvena.de";
    github = "frlan";
    githubId = 1010248;
    name = "Frank Lanitz";
  };
  fro_ozen = {
    email = "fro_ozen@gmx.de";
    github = "froozen";
    githubId = 1943632;
    name = "fro_ozen";
  };
  frogamic = {
    email = "frogamic@protonmail.com";
    github = "frogamic";
    githubId = 10263813;
    name = "Dominic Shelton";
  };
  Frostman = {
    email = "me@slukjanov.name";
    github = "Frostman";
    githubId = 134872;
    name = "Sergei Lukianov";
  };
  frontsideair = {
    email = "photonia@gmail.com";
    github = "frontsideair";
    githubId = 868283;
    name = "Fatih Altinok";
  };
  fstamour = {
    email = "fr.st-amour@gmail.com";
    github = "fstamour";
    githubId = 2881922;
    name = "Francis St-Amour";
  };
  ftrvxmtrx = {
    email = "ftrvxmtrx@gmail.com";
    github = "ftrvxmtrx";
    githubId = 248148;
    name = "Sigrid Solveig Haflínudóttir";
  };
  fuerbringer = {
    email = "severin@fuerbringer.info";
    github = "fuerbringer";
    githubId = 10528737;
    name = "Severin Fürbringer";
  };
  fufexan = {
    email = "fufexan@protonmail.com";
    github = "fufexan";
    githubId = 36706276;
    name = "Fufezan Mihai";
  };
  fusion809 = {
    email = "brentonhorne77@gmail.com";
    github = "fusion809";
    githubId = 4717341;
    name = "Brenton Horne";
  };
  fuuzetsu = {
    email = "fuuzetsu@fuuzetsu.co.uk";
    github = "Fuuzetsu";
    githubId = 893115;
    name = "Mateusz Kowalczyk";
  };
  fuzen = {
    email = "me@fuzen.cafe";
    github = "Fuzen-py";
    githubId = 17859309;
    name = "Fuzen";
  };
  fxfactorial = {
    email = "edgar.factorial@gmail.com";
    github = "fxfactorial";
    githubId = 3036816;
    name = "Edgar Aroutiounian";
  };
  gabesoft = {
    email = "gabesoft@gmail.com";
    github = "gabesoft";
    githubId = 606000;
    name = "Gabriel Adomnicai";
  };
  Gabriel439 = {
    email = "Gabriel439@gmail.com";
    github = "Gabriella439";
    githubId = 1313787;
    name = "Gabriel Gonzalez";
  };
  gador = {
    email = "florian.brandes@posteo.de";
    github = "gador";
    githubId = 1883533;
    name = "Florian Brandes";
    keys = [{
      fingerprint = "0200 3EF8 8D2B CF2D 8F00  FFDC BBB3 E40E 5379 7FD9";
    }];
  };
  GaetanLepage = {
    email = "gaetan@glepage.com";
    github = "GaetanLepage";
    githubId = 33058747;
    name = "Gaetan Lepage";
  };
  gal_bolle = {
    email = "florent.becker@ens-lyon.org";
    github = "FlorentBecker";
    githubId = 7047019;
    name = "Florent Becker";
  };
  galagora = {
    email = "lightningstrikeiv@gmail.com";
    github = "Galagora";
    githubId = 45048741;
    name = "Alwanga Oyango";
  };
  gamb = {
    email = "adam.gamble@pm.me";
    github = "gamb";
    githubId = 293586;
    name = "Adam Gamble";
  };
  garbas = {
    email = "rok@garbas.si";
    github = "garbas";
    githubId = 20208;
    name = "Rok Garbas";
  };
  gardspirito = {
    name = "gardspirito";
    email = "nyxoroso@gmail.com";
    github = "gardspirito";
    githubId = 29687558;
  };
  garrison = {
    email = "jim@garrison.cc";
    github = "garrison";
    githubId = 91987;
    name = "Jim Garrison";
  };
  gavin = {
    email = "gavin.rogers@holo.host";
    github = "gavinrogers";
    githubId = 2430469;
    name = "Gavin Rogers";
  };
  gazally = {
    email = "gazally@runbox.com";
    github = "gazally";
    githubId = 16470252;
    name = "Gemini Lasswell";
  };
  gbpdt = {
    email = "nix@pdtpartners.com";
    github = "gbpdt";
    githubId = 25106405;
    name = "Graham Bennett";
  };
  gbtb = {
    email = "goodbetterthebeast3@gmail.com";
    github = "gbtb";
    githubId = 37017396;
    name = "gbtb";
  };
  gdamjan = {
    email = "gdamjan@gmail.com";
    matrix = "@gdamjan:spodeli.org";
    github = "gdamjan";
    githubId = 81654;
    name = "Damjan Georgievski";
  };
  gdinh = {
    email = "nix@contact.dinh.ai";
    github = "gdinh";
    githubId = 34658064;
    name = "Grace Dinh";
  };
  gebner = {
    email = "gebner@gebner.org";
    github = "gebner";
    githubId = 313929;
    name = "Gabriel Ebner";
  };
  genofire = {
    name = "genofire";
    email = "geno+dev@fireorbit.de";
    github = "genofire";
    githubId = 6905586;
    keys = [{
      fingerprint = "386E D1BF 848A BB4A 6B4A  3C45 FC83 907C 125B C2BC";
    }];
  };
  georgesalkhouri = {
    name = "Georges Alkhouri";
    email = "incense.stitch_0w@icloud.com";
    github = "GeorgesAlkhouri";
    githubId = 6077574;
    keys = [{
      fingerprint = "1608 9E8D 7C59 54F2 6A7A 7BD0 8BD2 09DC C54F D339";
    }];
  };
  georgewhewell = {
    email = "georgerw@gmail.com";
    github = "georgewhewell";
    githubId = 1176131;
    name = "George Whewell";
  };
  georgyo = {
    email = "george@shamm.as";
    github = "georgyo";
    githubId = 19374;
    name = "George Shammas";
    keys = [{
      fingerprint = "D0CF 440A A703 E0F9 73CB  A078 82BB 70D5 41AE 2DB4";
    }];
  };
  gerschtli = {
    email = "tobias.happ@gmx.de";
    github = "Gerschtli";
    githubId = 10353047;
    name = "Tobias Happ";
  };
  gfrascadorio = {
    email = "gfrascadorio@tutanota.com";
    github = "gfrascadorio";
    githubId = 37602871;
    name = "Galois";
  };
  ggpeti = {
    email = "ggpeti@gmail.com";
    matrix = "@ggpeti:ggpeti.com";
    github = "ggPeti";
    githubId = 3217744;
    name = "Peter Ferenczy";
  };
  ghostbuster91 = {
    name = "Kasper Kondzielski";
    email = "kghost0@gmail.com";
    github = "ghostbuster91";
    githubId = 5662622;
  };
  ghuntley = {
    email = "ghuntley@ghuntley.com";
    github = "ghuntley";
    githubId = 127353;
    name = "Geoffrey Huntley";
  };
  gila = {
    email = "jeffry.molanus@gmail.com";
    github = "gila";
    githubId = 15957973;
    name = "Jeffry Molanus";
  };
  gilice = {
    email = "gilice@proton.me";
    github = "gilice";
    githubId = 104317939;
    name = "gilice";
  };
  gilligan = {
    email = "tobias.pflug@gmail.com";
    github = "gilligan";
    githubId = 27668;
    name = "Tobias Pflug";
  };
  gin66 = {
    email = "jochen@kiemes.de";
    github = "gin66";
    githubId = 5549373;
    name = "Jochen Kiemes";
  };
  giogadi = {
    email = "lgtorres42@gmail.com";
    github = "giogadi";
    githubId = 1713676;
    name = "Luis G. Torres";
  };
  GKasparov = {
    email = "mizozahr@gmail.com";
    github = "GKasparov";
    githubId = 60962839;
    name = "Mazen Zahr";
  };
  gkleen = {
    name = "Gregor Kleen";
    email = "xpnfr@bouncy.email";
    github = "gkleen";
    githubId = 20089782;
  };
  gleber = {
    email = "gleber.p@gmail.com";
    github = "gleber";
    githubId = 33185;
    name = "Gleb Peregud";
  };
  glenns = {
    email = "glenn.searby@gmail.com";
    github = "GlennS";
    githubId = 615606;
    name = "Glenn Searby";
  };
  glittershark = {
    name = "Griffin Smith";
    email = "root@gws.fyi";
    github = "glittershark";
    githubId = 1481027;
    keys = [{
      fingerprint = "0F11 A989 879E 8BBB FDC1  E236 44EF 5B5E 861C 09A7";
    }];
  };
  gloaming = {
    email = "ch9871@gmail.com";
    github = "gloaming";
    githubId = 10156748;
    name = "Craig Hall";
  };
  globin = {
    email = "mail@glob.in";
    github = "globin";
    githubId = 1447245;
    name = "Robin Gloster";
  };
  gnxlxnxx = {
    email = "gnxlxnxx@web.de";
    github = "gnxlxnxx";
    githubId = 25820499;
    name = "Roman Kretschmer";
  };
  goertzenator = {
    email = "daniel.goertzen@gmail.com";
    github = "goertzenator";
    githubId = 605072;
    name = "Daniel Goertzen";
  };
  goibhniu = {
    email = "cillian.deroiste@gmail.com";
    github = "cillianderoiste";
    githubId = 643494;
    name = "Cillian de Róiste";
  };
  GoldsteinE = {
    email = "root@goldstein.rs";
    github = "GoldsteinE";
    githubId = 12019211;
    name = "Maximilian Siling";
    keys = [{
      fingerprint = "0BAF 2D87 CB43 746F 6237  2D78 DE60 31AB A0BB 269A";
    }];
  };
  Gonzih = {
    email = "gonzih@gmail.com";
    github = "Gonzih";
    githubId = 266275;
    name = "Max Gonzih";
  };
  goodrone = {
    email = "goodrone@gmail.com";
    github = "goodrone";
    githubId = 1621335;
    name = "Andrew Trachenko";
  };
  gordias = {
    name = "Gordias";
    email = "gordias@disroot.org";
    github = "gordiasdot";
    githubId = 94724133;
    keys = [{
      fingerprint = "C006 B8A0 0618 F3B6 E0E4  2ECD 5D47 2848 30FA A4FA";
    }];
  };
  gotcha = {
    email = "gotcha@bubblenet.be";
    github = "gotcha";
    githubId = 105204;
    name = "Godefroid Chapelle";
  };
  govanify = {
    name = "Gauvain 'GovanifY' Roussel-Tarbouriech";
    email = "gauvain@govanify.com";
    github = "GovanifY";
    githubId = 6375438;
    keys = [{
      fingerprint = "5214 2D39 A7CE F8FA 872B  CA7F DE62 E1E2 A614 5556";
    }];
  };
  gp2112 = {
    email = "me@guip.dev";
    github = "gp2112";
    githubId = 26512375;
    name = "Guilherme Paixão";
    keys = [{
      fingerprint = "4382 7E28 86E5 C34F 38D5  7753 8C81 4D62 5FBD 99D1";
    }];
  };
  gpanders = {
    name = "Gregory Anders";
    email = "greg@gpanders.com";
    github = "gpanders";
    githubId = 8965202;
    keys = [{
      fingerprint = "B9D5 0EDF E95E ECD0 C135  00A9 56E9 3C2F B6B0 8BDB";
    }];
  };
  gpl = {
    email = "nixos-6c64ce18-bbbc-414f-8dcb-f9b6b47fe2bc@isopleth.org";
    github = "gpl";
    githubId = 39648069;
    name = "isogram";
  };
  gpyh = {
    email = "yacine.hmito@gmail.com";
    github = "yacinehmito";
    githubId = 6893840;
    name = "Yacine Hmito";
  };
  graham33 = {
    email = "graham@grahambennett.org";
    github = "graham33";
    githubId = 10908649;
    name = "Graham Bennett";
  };
  grahamc = {
    email = "graham@grahamc.com";
    github = "grahamc";
    githubId = 76716;
    name = "Graham Christensen";
  };
  gravndal = {
    email = "gaute.ravndal+nixos@gmail.com";
    github = "gravndal";
    githubId = 4656860;
    name = "Gaute Ravndal";
  };
  graysonhead = {
    email = "grayson@graysonhead.net";
    github = "graysonhead";
    githubId = 6179496;
    name = "Grayson Head";
  };
  grburst = {
    email = "GRBurst@protonmail.com";
    github = "GRBurst";
    githubId = 4647221;
    name = "GRBurst";
    keys = [{
      fingerprint = "7FC7 98AB 390E 1646 ED4D  8F1F 797F 6238 68CD 00C2";
    }];
  };
  greizgh = {
    email = "greizgh@ephax.org";
    github = "greizgh";
    githubId = 1313624;
    name = "greizgh";
  };
  greydot = {
    email = "lanablack@amok.cc";
    github = "greydot";
    githubId = 7385287;
    name = "Lana Black";
  };
  gridaphobe = {
    email = "eric@seidel.io";
    github = "gridaphobe";
    githubId = 201997;
    name = "Eric Seidel";
  };
  grindhold = {
    name = "grindhold";
    email = "grindhold+nix@skarphed.org";
    github = "grindhold";
    githubId = 2592640;
  };
  gspia = {
    email = "iahogsp@gmail.com";
    github = "gspia";
    githubId = 3320792;
    name = "gspia";
  };
  guibert = {
    email = "david.guibert@gmail.com";
    github = "dguibert";
    githubId = 1178864;
    name = "David Guibert";
  };
  groodt = {
    email = "groodt@gmail.com";
    github = "groodt";
    githubId = 343415;
    name = "Greg Roodt";
  };
  grnnja = {
    email = "grnnja@gmail.com";
    github = "grnnja";
    githubId = 31556469;
    name = "Prem Netsuwan";
  };
  gruve-p = {
    email = "groestlcoin@gmail.com";
    github = "gruve-p";
    githubId = 11212268;
    name = "gruve-p";
  };
  gschwartz = {
    email = "gsch@pennmedicine.upenn.edu";
    github = "GregorySchwartz";
    githubId = 2490088;
    name = "Gregory Schwartz";
  };
  gtrunsec = {
    email = "gtrunsec@hardenedlinux.org";
    github = "GTrunSec";
    githubId = 21156405;
    name = "GuangTao Zhang";
  };
  guibou = {
    email = "guillaum.bouchard@gmail.com";
    github = "guibou";
    githubId = 9705357;
    name = "Guillaume Bouchard";
  };
  GuillaumeDesforges = {
    email = "aceus02@gmail.com";
    github = "GuillaumeDesforges";
    githubId = 1882000;
    name = "Guillaume Desforges";
  };
  guillaumekoenig = {
    email = "guillaume.edward.koenig@gmail.com";
    github = "guillaumekoenig";
    githubId = 10654650;
    name = "Guillaume Koenig";
  };
  guserav = {
    email = "guserav@users.noreply.github.com";
    github = "guserav";
    githubId = 28863828;
    name = "guserav";
  };
  guyonvarch = {
    email = "joris@guyonvarch.me";
    github = "guyonvarch";
    githubId = 6768842;
    name = "Joris Guyonvarch";
  };
  gvolpe = {
    email = "volpegabriel@gmail.com";
    github = "gvolpe";
    githubId = 443978;
    name = "Gabriel Volpe";
  };
  gytis-ivaskevicius = {
    name = "Gytis Ivaskevicius";
    email = "me@gytis.io";
    matrix = "@gytis-ivaskevicius:matrix.org";
    github = "gytis-ivaskevicius";
    githubId = 23264966;
  };
  h7x4 = {
    name = "h7x4";
    email = "h7x4@nani.wtf";
    matrix = "@h7x4:nani.wtf";
    github = "h7x4";
    githubId = 14929991;
    keys = [{
      fingerprint = "F7D3 7890 228A 9074 40E1  FD48 46B9 228E 814A 2AAC";
    }];
  };
  hagl = {
    email = "harald@glie.be";
    github = "hagl";
    githubId = 1162118;
    name = "Harald Gliebe";
  };
  hakuch = {
    email = "hakuch@gmail.com";
    github = "hakuch";
    githubId = 1498782;
    name = "Jesse Haber-Kucharsky";
  };
  hamburger1984 = {
    email = "hamburger1984@gmail.com";
    github = "hamburger1984";
    githubId = 438976;
    name = "Andreas Krohn";
  };
  hamhut1066 = {
    email = "github@hamhut1066.com";
    github = "moredhel";
    githubId = 1742172;
    name = "Hamish Hutchings";
  };
  hanemile = {
    email = "mail@emile.space";
    github = "HanEmile";
    githubId = 22756350;
    name = "Emile Hansmaennel";
  };
  hansjoergschurr = {
    email = "commits@schurr.at";
    github = "hansjoergschurr";
    githubId = 9850776;
    name = "Hans-Jörg Schurr";
  };
  HaoZeke = {
    email = "r95g10@gmail.com";
    github = "HaoZeke";
    githubId = 4336207;
    name = "Rohit Goswami";
    keys = [{
      fingerprint = "74B1 F67D 8E43 A94A 7554  0768 9CCC E364 02CB 49A6";
    }];
  };
  happyalu = {
    email = "alok@parlikar.com";
    github = "happyalu";
    githubId = 231523;
    name = "Alok Parlikar";
  };
  happysalada = {
    email = "raphael@megzari.com";
    matrix = "@happysalada:matrix.org";
    github = "happysalada";
    githubId = 5317234;
    name = "Raphael Megzari";
  };
  happy-river = {
    email = "happyriver93@runbox.com";
    github = "happy-river";
    githubId = 54728477;
    name = "Happy River";
  };
  hardselius = {
    email = "martin@hardselius.dev";
    github = "hardselius";
    githubId = 1422583;
    name = "Martin Hardselius";
    keys = [{
      fingerprint = "3F35 E4CA CBF4 2DE1 2E90  53E5 03A6 E6F7 8693 6619";
    }];
  };
  harrisonthorne = {
    email = "harrisonthorne@proton.me";
    github = "harrisonthorne";
    githubId = 33523827;
    name = "Harrison Thorne";
  };
  harvidsen = {
    email = "harvidsen@gmail.com";
    github = "harvidsen";
    githubId = 62279738;
    name = "Håkon Arvidsen";
  };
  haslersn = {
    email = "haslersn@fius.informatik.uni-stuttgart.de";
    github = "haslersn";
    githubId = 33969028;
    name = "Sebastian Hasler";
  };
  havvy = {
    email = "ryan.havvy@gmail.com";
    github = "Havvy";
    githubId = 731722;
    name = "Ryan Scheel";
  };
  hawkw = {
    email = "eliza@elizas.website";
    github = "hawkw";
    githubId = 2796466;
    name = "Eliza Weisman";
  };
  hax404 = {
    email = "hax404foogit@hax404.de";
    matrix = "@hax404:hax404.de";
    github = "hax404";
    githubId = 1379411;
    name = "Georg Haas";
  };
  hbunke = {
    email = "bunke.hendrik@gmail.com";
    github = "hbunke";
    githubId = 1768793;
    name = "Hendrik Bunke";
  };
  hce = {
    email = "hc@hcesperer.org";
    github = "hce";
    githubId = 147689;
    name = "Hans-Christian Esperer";
  };
  hdhog = {
    name = "Serg Larchenko";
    email = "hdhog@hdhog.ru";
    github = "hdhog";
    githubId = 386666;
    keys = [{
      fingerprint = "A25F 6321 AAB4 4151 4085  9924 952E ACB7 6703 BA63";
    }];
  };
  hectorj = {
    email = "hector.jusforgues+nixos@gmail.com";
    github = "hectorj";
    githubId = 2427959;
    name = "Hector Jusforgues";
  };
  hedning = {
    email = "torhedinbronner@gmail.com";
    github = "hedning";
    githubId = 71978;
    name = "Tor Hedin Brønner";
  };
  heel = {
    email = "parizhskiy@gmail.com";
    github = "HeeL";
    githubId = 287769;
    name = "Sergii Paryzhskyi";
  };
  helkafen = {
    email = "arnaudpourseb@gmail.com";
    github = "Helkafen";
    githubId = 2405974;
    name = "Sébastian Méric de Bellefon";
  };
  helium = {
    email = "helium.dev@tuta.io";
    github = "helium18";
    githubId = 86223025;
    name = "helium";
  };
  henkkalkwater = {
    email = "chris+nixpkgs@netsoj.nl";
    github = "HenkKalkwater";
    githubId = 4262067;
    matrix = "@chris:netsoj.nl";
    name = "Chris Josten";
  };
  henkery = {
    email = "jim@reupload.nl";
    github = "henkery";
    githubId = 1923309;
    name = "Jim van Abkoude";
  };
  henrikolsson = {
    email = "henrik@fixme.se";
    github = "henrikolsson";
    githubId = 982322;
    name = "Henrik Olsson";
  };
  henrytill = {
    email = "henrytill@gmail.com";
    github = "henrytill";
    githubId = 6430643;
    name = "Henry Till";
  };
  heph2 = {
    email = "srht@mrkeebs.eu";
    github = "heph2";
    githubId = 87579883;
    name = "Marco";
  };
  herberteuler = {
    email = "herberteuler@gmail.com";
    github = "herberteuler";
    githubId = 1401179;
    name = "Guanpeng Xu";
  };
  hexa = {
    email = "hexa@darmstadt.ccc.de";
    matrix = "@hexa:lossy.network";
    github = "mweinelt";
    githubId = 131599;
    name = "Martin Weinelt";
  };
  hexagonal-sun = {
    email = "dev@mattleach.net";
    github = "hexagonal-sun";
    githubId = 222664;
    name = "Matthew Leach";
  };
  hexchen = {
    email = "nix@lilwit.ch";
    github = "hexchen";
    githubId = 41522204;
    name = "hexchen";
  };
  hh = {
    email = "hh@m-labs.hk";
    github = "HarryMakes";
    githubId = 66358631;
    name = "Harry Ho";
  };
  hhm = {
    email = "heehooman+nixpkgs@gmail.com";
    github = "hhm0";
    githubId = 3656888;
    name = "hhm";
  };
  hhydraa = {
    email = "hcurfman@keemail.me";
    github = "hhydraa";
    githubId = 58676303;
    name = "hhydraa";
  };
  higebu = {
    name = "Yuya Kusakabe";
    email = "yuya.kusakabe@gmail.com";
    github = "higebu";
    githubId = 733288;
  };
  hiljusti = {
    name = "J.R. Hill";
    email = "hiljusti@so.dang.cool";
    github = "hiljusti";
    githubId = 17605298;
  };
  hirenashah = {
    email = "hiren@hiren.io";
    github = "hirenashah";
    githubId = 19825977;
    name = "Hiren Shah";
  };
  hiro98 = {
    email = "hiro@protagon.space";
    github = "vale981";
    githubId = 4025991;
    name = "Valentin Boettcher";
    keys = [{
      fingerprint = "45A9 9917 578C D629 9F5F  B5B4 C22D 4DE4 D7B3 2D19";
    }];
  };
  hjones2199 = {
    email = "hjones2199@gmail.com";
    github = "hjones2199";
    githubId = 5525217;
    name = "Hunter Jones";
  };
  hkjn = {
    email = "me@hkjn.me";
    name = "Henrik Jonsson";
    github = "hkjn";
    githubId = 287215;
    keys = [{
      fingerprint = "D618 7A03 A40A 3D56 62F5  4B46 03EF BF83 9A5F DC15";
    }];
  };
  hleboulanger = {
    email = "hleboulanger@protonmail.com";
    name = "Harold Leboulanger";
    github = "thbkrshw";
    githubId = 33122;
  };
  hlolli = {
    email = "hlolli@gmail.com";
    github = "hlolli";
    githubId = 6074754;
    name = "Hlodver Sigurdsson";
  };
  huantian = {
    name = "David Li";
    email = "davidtianli@gmail.com";
    matrix = "@huantian:huantian.dev";
    github = "huantianad";
    githubId = 20760920;
    keys = [{
      fingerprint = "731A 7A05 AD8B 3AE5 956A  C227 4A03 18E0 4E55 5DE5";
    }];
  };
  hugoreeves = {
    email = "hugo@hugoreeves.com";
    github = "HugoReeves";
    githubId = 20039091;
    name = "Hugo Reeves";
    keys = [{
      fingerprint = "78C2 E81C 828A 420B 269A  EBC1 49FA 39F8 A7F7 35F9";
    }];
  };
  humancalico = {
    email = "humancalico@disroot.org";
    github = "humancalico";
    githubId = 51334444;
    name = "Akshat Agarwal";
  };
  hodapp = {
    email = "hodapp87@gmail.com";
    github = "Hodapp87";
    githubId = 896431;
    name = "Chris Hodapp";
  };
  hollowman6 = {
    email = "hollowman@hollowman.ml";
    github = "HollowMan6";
    githubId = 43995067;
    name = "Songlin Jiang";
  };
  holymonson = {
    email = "holymonson@gmail.com";
    github = "holymonson";
    githubId = 902012;
    name = "Monson Shao";
  };
  hongchangwu = {
    email = "wuhc85@gmail.com";
    github = "hongchangwu";
    githubId = 362833;
    name = "Hongchang Wu";
  };
  hoppla20 = {
    email = "privat@vincentcui.de";
    github = "hoppla20";
    githubId = 25618740;
    name = "Vincent Cui";
  };
  houstdav000 = {
    email = "houstdav000@gmail.com";
    github = "houstdav000";
    githubId = 17628961;
    matrix = "@houstdav000:gh0st.ems.host";
    name = "David Houston";
  };
  hoverbear = {
    email = "operator+nix@hoverbear.org";
    matrix = "@hoverbear:matrix.org";
    github = "Hoverbear";
    githubId = 130903;
    name = "Ana Hobden";
  };
  holgerpeters = {
    name = "Holger Peters";
    email = "holger.peters@posteo.de";
    github = "HolgerPeters";
    githubId = 4097049;
  };
  hqurve = {
    email = "hqurve@outlook.com";
    github = "hqurve";
    githubId = 53281855;
    name = "hqurve";
  };
  hrdinka = {
    email = "c.nix@hrdinka.at";
    github = "hrdinka";
    githubId = 1436960;
    name = "Christoph Hrdinka";
  };
  hrhino = {
    email = "hora.rhino@gmail.com";
    github = "hrhino";
    githubId = 28076058;
    name = "Harrison Houghton";
  };
  hschaeidt = {
    email = "he.schaeidt@gmail.com";
    github = "hschaeidt";
    githubId = 1614615;
    name = "Hendrik Schaeidt";
  };
  htr = {
    email = "hugo@linux.com";
    github = "htr";
    githubId = 39689;
    name = "Hugo Tavares Reis";
  };
  hufman = {
    email = "hufman@gmail.com";
    github = "hufman";
    githubId = 1592375;
    name = "Walter Huf";
  };
  hugolgst = {
    email = "hugo.lageneste@pm.me";
    github = "hugolgst";
    githubId = 15371828;
    name = "Hugo Lageneste";
  };
  huyngo = {
    email = "huyngo@disroot.org";
    github = "Huy-Ngo";
    name = "Ngô Ngọc Đức Huy";
    githubId = 19296926;
    keys = [{
      fingerprint = "DF12 23B1 A9FD C5BE 3DA5  B6F7 904A F1C7 CDF6 95C3";
    }];
  };
  hypersw = {
    email = "baltic@hypersw.net";
    github = "hypersw";
    githubId = 2332070;
    name = "Serge Baltic";
  };
  hyphon81 = {
    email = "zero812n@gmail.com";
    github = "hyphon81";
    githubId = 12491746;
    name = "Masato Yonekawa";
  };
  hyshka = {
    name = "Bryan Hyshka";
    email = "bryan@hyshka.com";
    github = "hyshka";
    githubId = 2090758;
    keys = [{
      fingerprint = "24F4 1925 28C4 8797 E539  F247 DB2D 93D1 BFAA A6EA";
    }];
  };
  hyzual = {
    email = "hyzual@gmail.com";
    github = "Hyzual";
    githubId = 2051507;
    name = "Joris Masson";
  };
  hzeller = {
    email = "h.zeller@acm.org";
    github = "hzeller";
    githubId = 140937;
    name = "Henner Zeller";
  };
  i077 = {
    email = "nixpkgs@imranhossa.in";
    github = "i077";
    githubId = 2789926;
    name = "Imran Hossain";
  };
  iagoq = {
    email = "18238046+iagocq@users.noreply.github.com";
    github = "iagocq";
    githubId = 18238046;
    name = "Iago Manoel Brito";
    keys = [{
      fingerprint = "DF90 9D58 BEE4 E73A 1B8C  5AF3 35D3 9F9A 9A1B C8DA";
    }];
  };
  iammrinal0 = {
    email = "nixpkgs@mrinalpurohit.in";
    matrix = "@iammrinal0:nixos.dev";
    github = "iAmMrinal0";
    githubId = 890062;
    name = "Mrinal";
  };
  iand675 = {
    email = "ian@iankduncan.com";
    github = "iand675";
    githubId = 69209;
    name = "Ian Duncan";
  };
  ianmjones = {
    email = "ian@ianmjones.com";
    github = "ianmjones";
    githubId = 4710;
    name = "Ian M. Jones";
  };
  ianwookim = {
    email = "ianwookim@gmail.com";
    github = "wavewave";
    githubId = 1031119;
    name = "Ian-Woo Kim";
  };
  ibizaman = {
    email = "ibizapeanut@gmail.com";
    github = "ibizaman";
    githubId = 1044950;
    name = "Pierre Penninckx";
    keys = [{
      fingerprint = "A01F 10C6 7176 B2AE 2A34  1A56 D4C5 C37E 6031 A3FE";
    }];
  };
  iblech = {
    email = "iblech@speicherleck.de";
    github = "iblech";
    githubId = 3661115;
    name = "Ingo Blechschmidt";
  };
  icewind1991 = {
    name = "Robin Appelman";
    email = "robin@icewind.nl";
    github = "icewind1991";
    githubId = 1283854;
  };
  icy-thought = {
    name = "Icy-Thought";
    email = "gilganyx@pm.me";
    matrix = "@gilganix:matrix.org";
    github = "Icy-Thought";
    githubId = 53710398;
  };
  idontgetoutmuch = {
    email = "dominic@steinitz.org";
    github = "idontgetoutmuch";
    githubId = 1550265;
    name = "Dominic Steinitz";
  };
  ifurther = {
    email = "55025025+ifurther@users.noreply.github.com";
    github = "ifurther";
    githubId = 55025025;
    name = "Feather Lin";
  };
  igsha = {
    email = "igor.sharonov@gmail.com";
    github = "igsha";
    githubId = 5345170;
    name = "Igor Sharonov";
  };
  iimog = {
    email = "iimog@iimog.org";
    github = "iimog";
    githubId = 7403236;
    name = "Markus J. Ankenbrand";
  };
  ikervagyok = {
    email = "ikervagyok@gmail.com";
    github = "ikervagyok";
    githubId = 7481521;
    name = "Balázs Lengyel";
  };
  ilian = {
    email = "ilian@tuta.io";
    github = "ilian";
    githubId = 25505957;
    name = "Ilian";
  };
  ilikeavocadoes = {
    email = "ilikeavocadoes@hush.com";
    github = "ilikeavocadoes";
    githubId = 36193715;
    name = "Lassi Haasio";
  };
  ilkecan = {
    email = "ilkecan@protonmail.com";
    matrix = "@ilkecan:matrix.org";
    github = "ilkecan";
    githubId = 40234257;
    name = "ilkecan bozdogan";
  };
  imincik = {
    email = "ivan.mincik@gmail.com";
    matrix = "@imincik:matrix.org";
    github = "imincik";
    githubId = 476346;
    name = "Ivan Mincik";
  };
  not-my-segfault = {
    email = "michal@tar.black";
    matrix = "@michal:tar.black";
    github = "not-my-segfault";
    githubId = 30374463;
    name = "Michal S.";
  };
  illegalprime = {
    email = "themichaeleden@gmail.com";
    github = "illegalprime";
    githubId = 4401220;
    name = "Michael Eden";
  };
  illiusdope = {
    email = "mat@marini.ca";
    github = "illiusdope";
    githubId = 61913481;
    name = "Mat Marini";
  };
  illustris = {
    email = "me@illustris.tech";
    github = "illustris";
    githubId = 3948275;
    name = "Harikrishnan R";
  };
  ilya-fedin = {
    email = "fedin-ilja2010@ya.ru";
    github = "ilya-fedin";
    githubId = 17829319;
    name = "Ilya Fedin";
  };
  ilya-kolpakov = {
    email = "ilya.kolpakov@gmail.com";
    github = "ilya-kolpakov";
    githubId = 592849;
    name = "Ilya Kolpakov";
  };
  ilyakooo0 = {
    name = "Ilya Kostyuchenko";
    email = "ilyakooo0@gmail.com";
    github = "ilyakooo0";
    githubId = 6209627;
  };
  imalison = {
    email = "IvanMalison@gmail.com";
    github = "IvanMalison";
    githubId = 1246619;
    name = "Ivan Malison";
  };
  imalsogreg = {
    email = "imalsogreg@gmail.com";
    github = "imalsogreg";
    githubId = 993484;
    name = "Greg Hale";
  };
  imgabe = {
    email = "gabrielpmonte@hotmail.com";
    github = "ImGabe";
    githubId = 24387926;
    name = "Gabriel Pereira";
  };
  imlonghao = {
    email = "nixos@esd.cc";
    github = "imlonghao";
    githubId = 4951333;
    name = "Hao Long";
  };
  immae = {
    email = "ismael@bouya.org";
    matrix = "@immae:immae.eu";
    github = "immae";
    githubId = 510202;
    name = "Ismaël Bouya";
  };
  impl = {
    email = "noah@noahfontes.com";
    matrix = "@impl:matrix.org";
    github = "impl";
    githubId = 41129;
    name = "Noah Fontes";
    keys = [{
      fingerprint = "F5B2 BE1B 9AAD 98FE 2916  5597 3665 FFF7 9D38 7BAA";
    }];
  };
  imsofi = {
    email = "sofi+git@mailbox.org";
    github = "imsofi";
    githubId = 20756843;
    name = "Sofi";
  };
  imuli = {
    email = "i@imu.li";
    github = "imuli";
    githubId = 4085046;
    name = "Imuli";
  };
  ineol = {
    email = "leo.stefanesco@gmail.com";
    github = "ineol";
    githubId = 37965;
    name = "Léo Stefanesco";
  };
  indeednotjames = {
    email = "nix@indeednotjames.com";
    github = "IndeedNotJames";
    githubId = 55066419;
    name = "Emily Lange";
  };
  infinidoge = {
    name = "Infinidoge";
    email = "infinidoge@inx.moe";
    github = "Infinidoge";
    githubId = 22727114;
  };
  infinisil = {
    email = "contact@infinisil.com";
    matrix = "@infinisil:matrix.org";
    github = "infinisil";
    githubId = 20525370;
    name = "Silvan Mosberger";
    keys = [{
      fingerprint = "6C2B 55D4 4E04 8266 6B7D  DA1A 422E 9EDA E015 7170";
    }];
  };
  ingenieroariel = {
    email = "ariel@nunez.co";
    github = "ingenieroariel";
    githubId = 54999;
    name = "Ariel Nunez";
  };
  iopq = {
    email = "iop_jr@yahoo.com";
    github = "iopq";
    githubId = 1817528;
    name = "Igor Polyakov";
  };
  irenes = {
    name = "Irene Knapp";
    email = "ireneista@gmail.com";
    matrix = "@irenes:matrix.org";
    github = "IreneKnapp";
    githubId = 157678;
    keys = [{
      fingerprint = "E864 BDFA AB55 36FD C905  5195 DBF2 52AF FB26 19FD";
    }];
  };
  ironpinguin = {
    email = "michele@catalano.de";
    github = "ironpinguin";
    githubId = 137306;
    name = "Michele Catalano";
  };
  isgy = {
    name = "isgy";
    email = "isgy@teiyg.com";
    github = "tgys";
    githubId = 13622947;
    keys = [{
      fingerprint = "1412 816B A9FA F62F D051 1975 D3E1 B013 B463 1293";
    }];
  };
  ius = {
    email = "j.de.gram@gmail.com";
    name = "Joerie de Gram";
    matrix = "@ius:nltrix.net";
    github = "ius";
    githubId = 529626;
  };
  ivan = {
    email = "ivan@ludios.org";
    github = "ivan";
    githubId = 4458;
    name = "Ivan Kozik";
  };
  ivan-babrou = {
    email = "nixpkgs@ivan.computer";
    name = "Ivan Babrou";
    github = "bobrik";
    githubId = 89186;
  };
  ivan-timokhin = {
    email = "nixpkgs@ivan.timokhin.name";
    name = "Ivan Timokhin";
    github = "ivan-timokhin";
    githubId = 9802104;
  };
  ivan-tkatchev = {
    email = "tkatchev@gmail.com";
    github = "ivan-tkatchev";
    githubId = 650601;
    name = "Ivan Tkatchev";
  };
  ivanbrennan = {
    email = "ivan.brennan@gmail.com";
    github = "ivanbrennan";
    githubId = 1672874;
    name = "Ivan Brennan";
    keys = [{
      fingerprint = "7311 2700 AB4F 4CDF C68C  F6A5 79C3 C47D C652 EA54";
    }];
  };
  ivankovnatsky = {
    email = "75213+ivankovnatsky@users.noreply.github.com";
    github = "ivankovnatsky";
    githubId = 75213;
    name = "Ivan Kovnatsky";
    keys = [{
      fingerprint = "6BD3 7248 30BD 941E 9180  C1A3 3A33 FA4C 82ED 674F";
    }];
  };
  ivar = {
    email = "ivar.scholten@protonmail.com";
    github = "IvarWithoutBones";
    githubId = 41924494;
    name = "Ivar";
  };
  iwanb = {
    email = "tracnar@gmail.com";
    github = "iwanb";
    githubId = 4035835;
    name = "Iwan";
  };
  ixmatus = {
    email = "parnell@digitalmentat.com";
    github = "ixmatus";
    githubId = 30714;
    name = "Parnell Springmeyer";
  };
  ixxie = {
    email = "matan@fluxcraft.net";
    github = "ixxie";
    githubId = 20320695;
    name = "Matan Bendix Shenhav";
  };
  izorkin = {
    email = "Izorkin@gmail.com";
    github = "Izorkin";
    githubId = 26877687;
    name = "Yurii Izorkin";
  };
  j0xaf = {
    email = "j0xaf@j0xaf.de";
    name = "Jörn Gersdorf";
    github = "j0xaf";
    githubId = 932697;
  };
  j0hax = {
    name = "Johannes Arnold";
    email = "johannes.arnold@stud.uni-hannover.de";
    github = "j0hax";
    githubId = 3802620;
  };
  j0lol = {
    name = "Jo";
    email = "me@j0.lol";
    github = "j0lol";
    githubId = 24716467;
  };
  j4m3s = {
    name = "James Landrein";
    email = "github@j4m3s.eu";
    github = "j4m3s-s";
    githubId = 9413812;
  };
  jacg = {
    name = "Jacek Generowicz";
    email = "jacg@my-post-office.net";
    github = "jacg";
    githubId = 2570854;
  };
  jakehamilton = {
    name = "Jake Hamilton";
    email = "jake.hamilton@hey.com";
    matrix = "@jakehamilton:matrix.org";
    github = "jakehamilton";
    githubId = 7005773;
    keys = [{
      fingerprint = "B982 0250 1720 D540 6A18  2DA8 188E 4945 E85B 2D21";
    }];
  };
  jasoncarr = {
    email = "jcarr250@gmail.com";
    github = "jasoncarr0";
    githubId = 6874204;
    name = "Jason Carr";
  };
  j-brn = {
    email = "me@bricker.io";
    github = "j-brn";
    githubId = 40566146;
    name = "Jonas Braun";
  };
  j-hui = {
    email = "j-hui@cs.columbia.edu";
    github = "j-hui";
    githubId = 11800204;
    name = "John Hui";
  };
  j-keck = {
    email = "jhyphenkeck@gmail.com";
    github = "j-keck";
    githubId = 3081095;
    name = "Jürgen Keck";
  };
  j03 = {
    email = "github@johannesloetzsch.de";
    github = "johannesloetzsch";
    githubId = 175537;
    name = "Johannes Lötzsch";
  };
  jackgerrits = {
    email = "jack@jackgerrits.com";
    github = "jackgerrits";
    githubId = 7558482;
    name = "Jack Gerrits";
  };
  jagajaga = {
    email = "ars.seroka@gmail.com";
    github = "jagajaga";
    githubId = 2179419;
    name = "Arseniy Seroka";
  };
  jakeisnt = {
    name = "Jacob Chvatal";
    email = "jake@isnt.online";
    github = "jakeisnt";
    githubId = 29869612;
  };
  jakelogemann = {
    email = "jake.logemann@gmail.com";
    github = "jakelogemann";
    githubId = 820715;
    name = "Jake Logemann";
  };
  jakestanger = {
    email = "mail@jstanger.dev";
    github = "JakeStanger";
    githubId = 5057870;
    name = "Jake Stanger";
  };
  jakewaksbaum = {
    email = "jake.waksbaum@gmail.com";
    github = "jbaum98";
    githubId = 5283991;
    name = "Jake Waksbaum";
  };
  jakubgs = {
    email = "jakub@gsokolowski.pl";
    github = "jakubgs";
    githubId = 2212681;
    name = "Jakub Grzgorz Sokołowski";
  };
  jamiemagee = {
    email = "jamie.magee@gmail.com";
    github = "JamieMagee";
    githubId = 1358764;
    name = "Jamie Magee";
  };
  jammerful = {
    email = "jammerful@gmail.com";
    github = "jammerful";
    githubId = 20176306;
    name = "jammerful";
  };
  jansol = {
    email = "jan.solanti@paivola.fi";
    github = "jansol";
    githubId = 2588851;
    name = "Jan Solanti";
  };
  jappie = {
    email = "jappieklooster@hotmail.com";
    github = "jappeace";
    githubId = 3874017;
    name = "Jappie Klooster";
  };
  javaguirre = {
    email = "contacto@javaguirre.net";
    github = "javaguirre";
    githubId = 488556;
    name = "Javier Aguirre";
  };
  jayesh-bhoot = {
    name = "Jayesh Bhoot";
    email = "jayesh@bhoot.sh";
    github = "jayeshbhoot";
    githubId = 1915507;
  };
  jb55 = {
    email = "jb55@jb55.com";
    github = "jb55";
    githubId = 45598;
    name = "William Casarin";
  };
  jbcrail = {
    name = "Joseph Crail";
    email = "jbcrail@gmail.com";
    github = "jbcrail";
    githubId = 6038;
  };
  jbedo = {
    email = "cu@cua0.org";
    matrix = "@jb:vk3.wtf";
    github = "jbedo";
    githubId = 372912;
    name = "Justin Bedő";
  };
  jbgi = {
    email = "jb@giraudeau.info";
    github = "jbgi";
    githubId = 221929;
    name = "Jean-Baptiste Giraudeau";
  };
  jc = {
    name = "Josh Cooper";
    email = "josh@cooper.is";
    github = "joshua-cooper";
    githubId = 35612334;
  };
  jceb = {
    name = "Jan Christoph Ebersbach";
    email = "jceb@e-jc.de";
    github = "jceb";
    githubId = 101593;
  };
  jchw = {
    email = "johnwchadwick@gmail.com";
    github = "jchv";
    githubId = 938744;
    name = "John Chadwick";
  };
  jcouyang = {
    email = "oyanglulu@gmail.com";
    github = "jcouyang";
    githubId = 1235045;
    name = "Jichao Ouyang";
    keys = [{
      fingerprint = "A506 C38D 5CC8 47D0 DF01  134A DA8B 833B 5260 4E63";
    }];
  };
  jcs090218 = {
    email = "jcs090218@gmail.com";
    github = "jcs090218";
    githubId = 8685505;
    name = "Jen-Chieh Shen";
  };
  jcumming = {
    email = "jack@mudshark.org";
    github = "jcumming";
    githubId = 1982341;
    name = "Jack Cummings";
  };
  jdagilliland = {
    email = "jdagilliland@gmail.com";
    github = "jdagilliland";
    githubId = 1383440;
    name = "Jason Gilliland";
  };
  jdahm = {
    email = "johann.dahm@gmail.com";
    github = "jdahm";
    githubId = 68032;
    name = "Johann Dahm";
  };
  jdanek = {
    email = "jdanek@redhat.com";
    github = "jirkadanek";
    githubId = 17877663;
    keys = [{
      fingerprint = "D4A6 F051 AD58 2E7C BCED  5439 6927 5CAD F15D 872E";
    }];
    name = "Jiri Daněk";
  };
  jdbaldry = {
    email = "jack.baldry@grafana.com";
    github = "jdbaldry";
    githubId = 4599384;
    name = "Jack Baldry";
  };
  jdehaas = {
    email = "qqlq@nullptr.club";
    github = "jeroendehaas";
    githubId = 117874;
    name = "Jeroen de Haas";
  };
  jdelStrother = {
    email = "me@delstrother.com";
    github = "jdelStrother";
    githubId = 2377;
    name = "Jonathan del Strother";
  };
  jdreaver = {
    email = "johndreaver@gmail.com";
    github = "jdreaver";
    githubId = 1253071;
    name = "David Reaver";
  };
  jduan = {
    name = "Jingjing Duan";
    email = "duanjingjing@gmail.com";
    github = "jduan";
    githubId = 452450;
  };
  jdupak = {
    name = "Jakub Dupak";
    email = "dev@jakubdupak.com";
    github = "jdupak";
    githubId = 22683640;
  };
  jecaro = {
    email = "jeancharles.quillet@gmail.com";
    github = "jecaro";
    githubId = 17029738;
    name = "Jean-Charles Quillet";
  };
  jefdaj = {
    email = "jefdaj@gmail.com";
    github = "jefdaj";
    githubId = 1198065;
    name = "Jeffrey David Johnson";
  };
  jefflabonte = {
    email = "grimsleepless@protonmail.com";
    github = "JeffLabonte";
    githubId = 9425955;
    name = "Jean-François Labonté";
  };
  jensbin = {
    email = "jensbin+git@pm.me";
    github = "jensbin";
    githubId = 1608697;
    name = "Jens Binkert";
  };
  jeremyschlatter = {
    email = "github@jeremyschlatter.com";
    github = "jeremyschlatter";
    githubId = 5741620;
    name = "Jeremy Schlatter";
  };
  jerith666 = {
    email = "github@matt.mchenryfamily.org";
    github = "jerith666";
    githubId = 854319;
    name = "Matt McHenry";
  };
  jeschli = {
    email = "jeschli@gmail.com";
    github = "0mbi";
    githubId = 10786794;
    name = "Markus Hihn";
  };
  jethro = {
    email = "jethrokuan95@gmail.com";
    github = "jethrokuan";
    githubId = 1667473;
    name = "Jethro Kuan";
  };
  jevy = {
    email = "jevin@quickjack.ca";
    github = "jevy";
    githubId = 110620;
    name = "Jevin Maltais";
  };
  jfb = {
    email = "james@yamtime.com";
    github = "tftio";
    githubId = 143075;
    name = "James Felix Black";
  };
  jfchevrette = {
    email = "jfchevrette@gmail.com";
    github = "jfchevrette";
    githubId = 3001;
    name = "Jean-Francois Chevrette";
    keys = [{
      fingerprint = "B612 96A9 498E EECD D5E9  C0F0 67A0 5858 0129 0DC6";
    }];
  };
  jflanglois = {
    email = "yourstruly@julienlanglois.me";
    github = "jflanglois";
    githubId = 18501;
    name = "Julien Langlois";
  };
  jfrankenau = {
    email = "johannes@frankenau.net";
    github = "jfrankenau";
    githubId = 2736480;
    name = "Johannes Frankenau";
  };
  jfroche = {
    name = "Jean-François Roche";
    email = "jfroche@pyxel.be";
    matrix = "@jfroche:matrix.pyxel.cloud";
    github = "jfroche";
    githubId = 207369;
    keys = [{
      fingerprint = "7EB1 C02A B62B B464 6D7C  E4AE D1D0 9DE1 69EA 19A0";
    }];
  };
  jgart = {
    email = "jgart@dismail.de";
    github = "jgarte";
    githubId = 47760695;
    name = "Jorge Gomez";
  };
  jgeerds = {
    email = "jascha@geerds.org";
    github = "jgeerds";
    githubId = 1473909;
    name = "Jascha Geerds";
  };
  jgertm = {
    email = "jger.tm@gmail.com";
    github = "jgertm";
    githubId = 6616642;
    name = "Tim Jaeger";
  };
  jgillich = {
    email = "jakob@gillich.me";
    github = "jgillich";
    githubId = 347965;
    name = "Jakob Gillich";
  };
  jglukasik = {
    email = "joseph@jgl.me";
    github = "jglukasik";
    githubId = 6445082;
    name = "Joseph Lukasik";
  };
  jhh = {
    email = "jeff@j3ff.io";
    github = "jhh";
    githubId = 14412;
    name = "Jeff Hutchison";
  };
  jhhuh = {
    email = "jhhuh.note@gmail.com";
    github = "jhhuh";
    githubId = 5843245;
    name = "Ji-Haeng Huh";
  };
  jhillyerd = {
    email = "james+nixos@hillyerd.com";
    github = "jhillyerd";
    githubId = 2502736;
    name = "James Hillyerd";
  };
  jiegec = {
    name = "Jiajie Chen";
    email = "c@jia.je";
    github = "jiegec";
    githubId = 6127678;
  };
  jiehong = {
    email = "nixos@majiehong.com";
    github = "Jiehong";
    githubId = 1061229;
    name = "Jiehong Ma";
  };
  jirkamarsik = {
    email = "jiri.marsik89@gmail.com";
    github = "jirkamarsik";
    githubId = 184898;
    name = "Jirka Marsik";
  };
  jitwit = {
    email = "jrn@bluefarm.ca";
    github = "jitwit";
    githubId = 51518420;
    name = "jitwit";
  };
  jjjollyjim = {
    email = "jamie@kwiius.com";
    github = "JJJollyjim";
    githubId = 691552;
    name = "Jamie McClymont";
  };
  jk = {
    email = "hello+nixpkgs@j-k.io";
    matrix = "@j-k:matrix.org";
    github = "06kellyjac";
    githubId = 9866621;
    name = "Jack";
  };
  jkarlson = {
    email = "jekarlson@gmail.com";
    github = "jkarlson";
    githubId = 1204734;
    name = "Emil Karlson";
  };
  jlamur = {
    email = "contact@juleslamur.fr";
    github = "jlamur";
    githubId = 7054317;
    name = "Jules Lamur";
    keys = [{
      fingerprint = "B768 6CD7 451A 650D 9C54  4204 6710 CF0C 1CBD 7762";
    }];
  };
  jlesquembre = {
    email = "jl@lafuente.me";
    github = "jlesquembre";
    githubId = 1058504;
    name = "José Luis Lafuente";
  };
  jloyet = {
    email = "ml@fatbsd.com";
    github = "fatpat";
    githubId = 822436;
    name = "Jérôme Loyet";
  };
  jluttine = {
    email = "jaakko.luttinen@iki.fi";
    github = "jluttine";
    githubId = 2195834;
    name = "Jaakko Luttinen";
  };
  jm2dev = {
    email = "jomarcar@gmail.com";
    github = "jm2dev";
    githubId = 474643;
    name = "José Miguel Martínez Carrasco";
  };
  jmagnusj = {
    email = "jmagnusj@gmail.com";
    github = "magnusjonsson";
    githubId = 8900;
    name = "Johan Magnus Jonsson";
  };
  jmc-figueira = {
    email = "business+nixos@jmc-figueira.dev";
    github = "jmc-figueira";
    githubId = 6634716;
    name = "João Figueira";
    keys = [
      # GitHub signing key
      {
        fingerprint = "EC08 7AA3 DEAD A972 F015  6371 DC7A E56A E98E 02D7";
      }
      # Email encryption
      {
        fingerprint = "816D 23F5 E672 EC58 7674  4A73 197F 9A63 2D13 9E30";
      }
    ];
  };
  jmettes = {
    email = "jonathan@jmettes.com";
    github = "jmettes";
    githubId = 587870;
    name = "Jonathan Mettes";
  };
  jmgilman = {
    email = "joshuagilman@gmail.com";
    github = "jmgilman";
    githubId = 2308444;
    name = "Joshua Gilman";
  };
  jo1gi = {
    email = "joakimholm@protonmail.com";
    github = "jo1gi";
    githubId = 26695750;
    name = "Joakim Holm";
  };
  joachifm = {
    email = "joachifm@fastmail.fm";
    github = "joachifm";
    githubId = 41977;
    name = "Joachim Fasting";
  };
  joachimschmidt557 = {
    email = "joachim.schmidt557@outlook.com";
    github = "joachimschmidt557";
    githubId = 28556218;
    name = "Joachim Schmidt";
  };
  joamaki = {
    email = "joamaki@gmail.com";
    github = "joamaki";
    githubId = 1102396;
    name = "Jussi Maki";
  };
  jobojeha = {
    email = "jobojeha@jeppener.de";
    github = "jobojeha";
    githubId = 60272884;
    name = "Jonathan Jeppener-Haltenhoff";
  };
  jocelynthode = {
    email = "jocelyn.thode@gmail.com";
    github = "jocelynthode";
    githubId = 3967312;
    name = "Jocelyn Thode";
  };
  joedevivo = {
     email = "55951+joedevivo@users.noreply.github.com";
     github = "joedevivo";
     githubId = 55951;
     name = "Joe DeVivo";
   };
  joelancaster = {
    email = "joe.a.lancas@gmail.com";
    github = "JoeLancaster";
    githubId = 16760945;
    name = "Joe Lancaster";
  };
  joelburget = {
    email = "joelburget@gmail.com";
    github = "joelburget";
    githubId = 310981;
    name = "Joel Burget";
  };
  joelkoen = {
    email = "mail@joelkoen.com";
    github = "joelkoen";
    githubId = 122502655;
    name = "Joel Koen";
  };
  joelmo = {
    email = "joel.moberg@gmail.com";
    github = "joelmo";
    githubId = 336631;
    name = "Joel Moberg";
  };
  joepie91 = {
    email = "admin@cryto.net";
    matrix = "@joepie91:pixie.town";
    name = "Sven Slootweg";
    github = "joepie91";
    githubId = 1663259;
  };
  joesalisbury = {
    email = "salisbury.joseph@gmail.com";
    github = "JosephSalisbury";
    githubId = 297653;
    name = "Joe Salisbury";
  };
  john-shaffer = {
    email = "jdsha@proton.me";
    github = "john-shaffer";
    githubId = 53870456;
    name = "John Shaffer";
  };
  johanot = {
    email = "write@ownrisk.dk";
    github = "johanot";
    githubId = 998763;
    name = "Johan Thomsen";
  };
  johbo = {
    email = "johannes@bornhold.name";
    github = "johbo";
    githubId = 117805;
    name = "Johannes Bornhold";
  };
  johnazoidberg = {
    email = "git@danielschaefer.me";
    github = "JohnAZoidberg";
    githubId = 5307138;
    name = "Daniel Schäfer";
  };
  johnchildren = {
    email = "john.a.children@gmail.com";
    github = "johnchildren";
    githubId = 32305209;
    name = "John Children";
  };
  johnmh = {
    email = "johnmh@openblox.org";
    github = "JohnMH";
    githubId = 2576152;
    name = "John M. Harris, Jr.";
  };
  johnramsden = {
    email = "johnramsden@riseup.net";
    github = "johnramsden";
    githubId = 8735102;
    name = "John Ramsden";
  };
  johnrichardrinehart = {
    email = "johnrichardrinehart@gmail.com";
    github = "johnrichardrinehart";
    githubId = 6321578;
    name = "John Rinehart";
  };
  johntitor = {
    email = "huyuumi.dev@gmail.com";
    github = "JohnTitor";
    githubId = 25030997;
    name = "Yuki Okushi";
  };
  jojosch = {
    name = "Johannes Schleifenbaum";
    email = "johannes@js-webcoding.de";
    matrix = "@jojosch:jswc.de";
    github = "jojosch";
    githubId = 327488;
    keys = [{
      fingerprint = "7249 70E6 A661 D84E 8B47  678A 0590 93B1 A278 BCD0";
    }];
  };
  joko = {
    email = "ioannis.koutras@gmail.com";
    github = "jokogr";
    githubId = 1252547;
    keys = [{
      # compare with https://keybase.io/joko
      fingerprint = "B154 A8F9 0610 DB45 0CA8  CF39 85EA E7D9 DF56 C5CA";
    }];
    name = "Ioannis Koutras";
  };
  jonaenz = {
    name = "Jona Enzinger";
    email = "5xt3zyy5l@mozmail.com";
    matrix = "@jona:matrix.jonaenz.de";
    github = "JonaEnz";
    githubId = 57130301;
    keys = [{
      fingerprint = "1CC5 B67C EB9A 13A5 EDF6 F10E 0B4A 3662 FC58 9202";
    }];
  };
  jonafato = {
    email = "jon@jonafato.com";
    github = "jonafato";
    githubId = 392720;
    name = "Jon Banafato";
  };
  jonathanmarler = {
    email = "johnnymarler@gmail.com";
    github = "marler8997";
    githubId = 304904;
    name = "Jonathan Marler";
  };
  jonathanreeve = {
    email = "jon.reeve@gmail.com";
    github = "JonathanReeve";
    githubId = 1843676;
    name = "Jonathan Reeve";
  };
  jonnybolton = {
    email = "jonnybolton@gmail.com";
    github = "jonnybolton";
    githubId = 8580434;
    name = "Jonny Bolton";
  };
  jonringer = {
    email = "jonringer117@gmail.com";
    matrix = "@jonringer:matrix.org";
    github = "jonringer";
    githubId = 7673602;
    name = "Jonathan Ringer";
  };
  jordanisaacs = {
    name = "Jordan Isaacs";
    email = "nix@jdisaacs.com";
    github = "jordanisaacs";
    githubId = 19742638;
  };
  jorise = {
    email = "info@jorisengbers.nl";
    github = "JorisE";
    githubId = 1767283;
    name = "Joris Engbers";
  };
  jorsn = {
    name = "Johannes Rosenberger";
    email = "johannes@jorsn.eu";
    github = "jorsn";
    githubId = 4646725;
  };
  joshuafern = {
    name = "Joshua Fern";
    email = "joshuafern@protonmail.com";
    github = "JoshuaFern";
    githubId = 4300747;
  };
  joshvanl = {
    email = " me@joshvanl.dev ";
    github = "JoshVanL";
    githubId = 15893072;
    name = "Josh van Leeuwen";
  };
  jpas = {
    name = "Jarrod Pas";
    email = "jarrod@jarrodpas.com";
    github = "jpas";
    githubId = 5689724;
  };
  jpdoyle = {
    email = "joethedoyle@gmail.com";
    github = "jpdoyle";
    githubId = 1918771;
    name = "Joe Doyle";
  };
  jperras = {
    email = "joel@nerderati.com";
    github = "jperras";
    githubId = 20675;
    name = "Joël Perras";
  };
  jpetrucciani = {
    email = "j@cobi.dev";
    github = "jpetrucciani";
    githubId = 8117202;
    name = "Jacobi Petrucciani";
  };
  jpierre03 = {
    email = "nix@prunetwork.fr";
    github = "jpierre03";
    githubId = 954536;
    name = "Jean-Pierre PRUNARET";
  };
  jpotier = {
    email = "jpo.contributes.to.nixos@marvid.fr";
    github = "jpotier";
    githubId = 752510;
    name = "Martin Potier";
  };
  jqqqqqqqqqq = {
    email = "jqqqqqqqqqq@gmail.com";
    github = "jqqqqqqqqqq";
    githubId = 12872927;
    name = "Curtis Jiang";
  };
  jqueiroz = {
    email = "nixos@johnjq.com";
    github = "jqueiroz";
    githubId = 4968215;
    name = "Jonathan Queiroz";
  };
  jraygauthier = {
    email = "jraygauthier@gmail.com";
    github = "jraygauthier";
    githubId = 4611077;
    name = "Raymond Gauthier";
  };
  jrpotter = {
    email = "jrpotter2112@gmail.com";
    github = "jrpotter";
    githubId = 3267697;
    name = "Joshua Potter";
  };
  jshcmpbll = {
    email = "me@joshuadcampbell.com";
    github = "jshcmpbll";
    githubId = 16374374;
    name = "Joshua Campbell";
  };
  jshholland = {
    email = "josh@inv.alid.pw";
    github = "jshholland";
    githubId = 107689;
    name = "Josh Holland";
  };
  jsierles = {
    email = "joshua@hey.com";
    matrix = "@jsierles:matrix.org";
    name = "Joshua Sierles";
    github = "jsierles";
    githubId = 82;
  };
  jsimonetti = {
    email = "jeroen+nixpkgs@simonetti.nl";
    matrix = "@jeroen:simonetti.nl";
    name = "Jeroen Simonetti";
    github = "jsimonetti";
    githubId = 5478838;
  };
  jsoo1 = {
    email = "jsoo1@asu.edu";
    github = "jsoo1";
    name = "John Soo";
    githubId = 10039785;
  };
  jtcoolen = {
    email = "jtcoolen@pm.me";
    name = "Julien Coolen";
    github = "jtcoolen";
    githubId = 54635632;
    keys = [{
      fingerprint = "4C68 56EE DFDA 20FB 77E8  9169 1964 2151 C218 F6F5";
    }];
  };
  jtobin = {
    email = "jared@jtobin.io";
    github = "jtobin";
    githubId = 1414434;
    name = "Jared Tobin";
  };
  jtojnar = {
    email = "jtojnar@gmail.com";
    matrix = "@jtojnar:matrix.org";
    github = "jtojnar";
    githubId = 705123;
    name = "Jan Tojnar";
  };
  jtrees = {
    email = "me@jtrees.io";
    github = "jtrees";
    githubId = 5802758;
    name = "Joshua Trees";
  };
  juaningan = {
    email = "juaningan@gmail.com";
    github = "uningan";
    githubId = 810075;
    name = "Juan Rodal";
  };
  juboba = {
    email = "juboba@gmail.com";
    github = "juboba";
    githubId = 1189739;
    name = "Julio Borja Barra";
  };
  jugendhacker = {
    name = "j.r";
    email = "j.r@jugendhacker.de";
    github = "jugendhacker";
    githubId = 12773748;
    matrix = "@j.r:chaos.jetzt";
  };
  juliendehos = {
    email = "dehos@lisic.univ-littoral.fr";
    github = "juliendehos";
    githubId = 11947756;
    name = "Julien Dehos";
  };
  julienmalka = {
    email = "julien.malka@me.com";
    github = "JulienMalka";
    githubId = 1792886;
    name = "Julien Malka";
  };
  julm = {
    email = "julm+nixpkgs@sourcephile.fr";
    github = "ju1m";
    githubId = 21160136;
    name = "Julien Moutinho";
  };
  jumper149 = {
    email = "felixspringer149@gmail.com";
    github = "jumper149";
    githubId = 39434424;
    name = "Felix Springer";
  };
  junjihashimoto = {
    email = "junji.hashimoto@gmail.com";
    github = "junjihashimoto";
    githubId = 2469618;
    name = "Junji Hashimoto";
  };
  justinas = {
    email = "justinas@justinas.org";
    github = "justinas";
    githubId = 662666;
    name = "Justinas Stankevičius";
  };
  justinlovinger = {
    email = "git@justinlovinger.com";
    github = "JustinLovinger";
    githubId = 7183441;
    name = "Justin Lovinger";
  };
  justinwoo = {
    email = "moomoowoo@gmail.com";
    github = "justinwoo";
    githubId = 2396926;
    name = "Justin Woo";
  };
  jvanbruegge = {
    email = "supermanitu@gmail.com";
    github = "jvanbruegge";
    githubId = 1529052;
    name = "Jan van Brügge";
    keys = [{
      fingerprint = "3513 5CE5 77AD 711F 3825  9A99 3665 72BE 7D6C 78A2";
    }];
  };
  jwatt = {
    email = "jwatt@broken.watch";
    github = "jjwatt";
    githubId = 2397327;
    name = "Jesse Wattenbarger";
  };
  jwiegley = {
    email = "johnw@newartisans.com";
    github = "jwiegley";
    githubId = 8460;
    name = "John Wiegley";
  };
  jwijenbergh = {
    email = "jeroenwijenbergh@protonmail.com";
    github = "jwijenbergh";
    githubId = 46386452;
    name = "Jeroen Wijenbergh";
  };
  jwoudenberg = {
    email = "nixpkgs@jasperwoudenberg.com";
    github = "jwoudenberg";
    githubId = 1525551;
    name = "Jasper Woudenberg";
  };
  jwygoda = {
    email = "jaroslaw@wygoda.me";
    github = "jwygoda";
    githubId = 20658981;
    name = "Jarosław Wygoda";
  };
  jyp = {
    email = "jeanphilippe.bernardy@gmail.com";
    github = "jyp";
    githubId = 27747;
    name = "Jean-Philippe Bernardy";
  };
  jzellner = {
    email = "jeffz@eml.cc";
    github = "sofuture";
    githubId = 66669;
    name = "Jeff Zellner";
  };
  k3a = {
    email = "git+nix@catmail.app";
    name = "Mario Hros";
    github = "k3a";
    githubId = 966992;
  };
  k900 = {
    name = "Ilya K.";
    email = "me@0upti.me";
    github = "K900";
    githubId = 386765;
    matrix = "@k900:0upti.me";
  };
  kaction = {
    name = "Dmitry Bogatov";
    email = "KAction@disroot.org";
    github = "KAction";
    githubId = 44864956;
    keys = [{
      fingerprint = "3F87 0A7C A7B4 3731 2F13  6083 749F D4DF A2E9 4236";
    }];
  };
  kaiha = {
    email = "kai.harries@gmail.com";
    github = "KaiHa";
    githubId = 6544084;
    name = "Kai Harries";
  };
  kalbasit = {
    email = "wael.nasreddine@gmail.com";
    matrix = "@kalbasit:matrix.org";
    github = "kalbasit";
    githubId = 87115;
    name = "Wael Nasreddine";
  };
  kalekseev = {
    email = "mail@kalekseev.com";
    github = "kalekseev";
    githubId = 367259;
    name = "Konstantin Alekseev";
  };
  kamadorueda = {
    name = "Kevin Amado";
    email = "kamadorueda@gmail.com";
    github = "kamadorueda";
    githubId = 47480384;
    keys = [{
      fingerprint = "2BE3 BAFD 793E A349 ED1F  F00F 04D0 CEAF 916A 9A40";
    }];
  };
  kamilchm = {
    email = "kamil.chm@gmail.com";
    github = "kamilchm";
    githubId = 1621930;
    name = "Kamil Chmielewski";
  };
  kampfschlaefer = {
    email = "arnold@arnoldarts.de";
    github = "kampfschlaefer";
    githubId = 3831860;
    name = "Arnold Krille";
  };
  kanashimia = {
    email = "chad@redpilled.dev";
    github = "kanashimia";
    githubId = 56224949;
    name = "Mia Kanashi";
  };
  karantan = {
    name = "Gasper Vozel";
    email = "karantan@gmail.com";
    github = "karantan";
    githubId = 7062631;
  };
  KarlJoad = {
    email = "karl@hallsby.com";
    github = "KarlJoad";
    githubId = 34152449;
    name = "Karl Hallsby";
  };
  karolchmist = {
    email = "info+nix@chmist.com";
    github = "karolchmist";
    githubId = 1927188;
    name = "karolchmist";
  };
  kayhide = {
    email = "kayhide@gmail.com";
    github = "kayhide";
    githubId = 1730718;
    name = "Hideaki Kawai";
  };
  kazcw = {
    email = "kaz@lambdaverse.org";
    github = "kazcw";
    githubId = 1047859;
    name = "Kaz Wesley";
  };
  kcalvinalvin = {
    email = "calvin@kcalvinalvin.info";
    github = "kcalvinalvin";
    githubId = 37185887;
    name = "Calvin Kim";
  };
  keksbg = {
    email = "keksbg@riseup.net";
    name = "Stella";
    github = "keksbg";
    githubId = 10682187;
    keys = [{
      fingerprint = "AB42 1F18 5A19 A160 AD77  9885 3D6D CA5B 6F2C 2A7A";
    }];
  };
  keldu = {
    email = "mail@keldu.de";
    github = "keldu";
    githubId = 15373888;
    name = "Claudius Holeksa";
  };
  ken-matsui = {
    email = "nix@kmatsui.me";
    github = "ken-matsui";
    githubId = 26405363;
    name = "Ken Matsui";
    keys = [{
      fingerprint = "3611 8CD3 6DE8 3334 B44A  DDE4 1033 60B3 298E E433";
    }];
  };
  kennyballou = {
    email = "kb@devnulllabs.io";
    github = "kennyballou";
    githubId = 2186188;
    name = "Kenny Ballou";
    keys = [{
      fingerprint = "932F 3E8E 1C0F 4A98 95D7  B8B8 B0CA A28A 0295 8308";
    }];
  };
  kenran = {
    email = "johannes.maier@mailbox.org";
    github = "kenranunderscore";
    githubId = 5188977;
    matrix = "@kenran_:matrix.org";
    name = "Johannes Maier";
  };
  kentjames = {
    email = "jameschristopherkent@gmail.com";
    github = "KentJames";
    githubId = 2029444;
    name = "James Kent";
  };
  kephasp = {
    email = "pierre@nothos.net";
    github = "kephas";
    githubId = 762421;
    name = "Pierre Thierry";
  };
  ketzacoatl = {
    email = "ketzacoatl@protonmail.com";
    github = "ketzacoatl";
    githubId = 10122937;
    name = "ketzacoatl";
  };
  kevincox = {
    email = "kevincox@kevincox.ca";
    matrix = "@kevincox:matrix.org";
    github = "kevincox";
    githubId = 494012;
    name = "Kevin Cox";
  };
  kevingriffin = {
    email = "me@kevin.jp";
    github = "kevingriffin";
    githubId = 209729;
    name = "Kevin Griffin";
  };
  kevink = {
    email = "kevin@kevink.dev";
    github = "Unkn0wnCat";
    githubId = 8211181;
    name = "Kevin Kandlbinder";
  };
  kfears = {
    email = "kfearsoff@gmail.com";
    github = "KFearsoff";
    githubId = 66781795;
    matrix = "@kfears:matrix.org";
    name = "KFears";
  };
  kfollesdal = {
    email = "kfollesdal@gmail.com";
    github = "kfollesdal";
    githubId = 546087;
    name = "Kristoffer K. Føllesdal";
  };
  kho-dialga = {
    email = "ivandashenyou@gmail.com";
    github = "Kho-Dialga";
    githubId = 55767703;
    name = "Iván Brito";
  };
  khumba = {
    email = "bog@khumba.net";
    github = "khumba";
    githubId = 788813;
    name = "Bryan Gardiner";
  };
  khushraj = {
    email = "khushraj.rathod@gmail.com";
    github = "khrj";
    githubId = 44947946;
    name = "Khushraj Rathod";
    keys = [{
      fingerprint = "1988 3FD8 EA2E B4EC 0A93  1E22 B77B 2A40 E770 2F19";
    }];
  };
  KibaFox = {
    email = "kiba.fox@foxypossibilities.com";
    github = "KibaFox";
    githubId = 16481032;
    name = "Kiba Fox";
  };
  kidd = {
    email = "raimonster@gmail.com";
    github = "kidd";
    githubId = 25607;
    name = "Raimon Grau";
  };
  kidonng = {
    email = "hi@xuann.wang";
    github = "kidonng";
    githubId = 44045911;
    name = "Kid";
  };
  kierdavis = {
    email = "kierdavis@gmail.com";
    github = "kierdavis";
    githubId = 845652;
    name = "Kier Davis";
  };
  kilimnik = {
    email = "mail@kilimnik.de";
    github = "kilimnik";
    githubId = 5883283;
    name = "Daniel Kilimnik";
  };
  killercup = {
    email = "killercup@gmail.com";
    github = "killercup";
    githubId = 20063;
    name = "Pascal Hertleif";
  };
  kiloreux = {
    email = "kiloreux@gmail.com";
    github = "kiloreux";
    githubId = 6282557;
    name = "Kiloreux Emperex";
  };
  kim0 = {
    email = "email.ahmedkamal@googlemail.com";
    github = "kim0";
    githubId = 59667;
    name = "Ahmed Kamal";
  };
  kimat = {
    email = "mail@kimat.org";
    github = "kimat";
    githubId = 3081769;
    name = "Kimat Boven";
  };
  kimburgess = {
    email = "kim@acaprojects.com";
    github = "kimburgess";
    githubId = 843652;
    name = "Kim Burgess";
  };
  kini = {
    email = "keshav.kini@gmail.com";
    github = "kini";
    githubId = 691290;
    name = "Keshav Kini";
  };
  kirelagin = {
    email = "kirelagin@gmail.com";
    matrix = "@kirelagin:matrix.org";
    github = "kirelagin";
    githubId = 451835;
    name = "Kirill Elagin";
  };
  kirikaza = {
    email = "k@kirikaza.ru";
    github = "kirikaza";
    githubId = 804677;
    name = "Kirill Kazakov";
  };
  kisonecat = {
    email = "kisonecat@gmail.com";
    github = "kisonecat";
    githubId = 148352;
    name = "Jim Fowler";
  };
  kittywitch = {
    email = "kat@inskip.me";
    github = "kittywitch";
    githubId = 67870215;
    name = "Kat Inskip";
    keys = [{
      fingerprint = "9CC6 44B5 69CD A59B C874  C4C9 E8DD E3ED 1C90 F3A0";
    }];
  };
  kiwi = {
    email = "envy1988@gmail.com";
    github = "Kiwi";
    githubId = 35715;
    name = "Robert Djubek";
    keys = [{
      fingerprint = "8992 44FC D291 5CA2 0A97  802C 156C 88A5 B0A0 4B2A";
    }];
  };
  kjeremy = {
    email = "kjeremy@gmail.com";
    name = "Jeremy Kolb";
    github = "kjeremy";
    githubId = 4325700;
  };
  klden = {
    name = "Kenzyme Le";
    email = "kl@kenzymele.com";
    github = "klDen";
    githubId = 5478260;
  };
  klntsky = {
    email = "klntsky@gmail.com";
    name = "Vladimir Kalnitsky";
    github = "klntsky";
    githubId = 18447310;
  };
  kloenk = {
    email = "me@kloenk.dev";
    matrix = "@kloenk:petabyte.dev";
    name = "Finn Behrens";
    github = "Kloenk";
    githubId = 12898828;
    keys = [{
      fingerprint = "6881 5A95 D715 D429 659B  48A4 B924 45CF C954 6F9D";
    }];
  };
  kmcopper = {
    email = "kmcopper@danwin1210.me";
    name = "Kyle Copperfield";
    github = "kmcopper";
    githubId = 57132115;
  };
  kmeakin = {
    email = "karlwfmeakin@gmail.com";
    name = "Karl Meakin";
    github = "Kmeakin";
    githubId = 19665139;
  };

  kmein = {
    email = "kmein@posteo.de";
    name = "Kierán Meinhardt";
    github = "kmein";
    githubId = 10352507;
  };
  kmicklas = {
    email = "maintainer@kmicklas.com";
    name = "Ken Micklas";
    github = "kmicklas";
    githubId = 929096;
  };
  knairda = {
    email = "adrian@kummerlaender.eu";
    name = "Adrian Kummerlaender";
    github = "KnairdA";
    githubId = 498373;
  };
  knedlsepp = {
    email = "josef.kemetmueller@gmail.com";
    github = "knedlsepp";
    githubId = 3287933;
    name = "Josef Kemetmüller";
  };
  knl = {
    email = "nikola@knezevic.co";
    github = "knl";
    githubId = 361496;
    name = "Nikola Knežević";
  };
  kolaente = {
    email = "k@knt.li";
    github = "kolaente";
    githubId = 13721712;
    name = "Konrad Langenberg";
  };
  kolbycrouch = {
    email = "kjc.devel@gmail.com";
    github = "kolbycrouch";
    githubId = 6346418;
    name = "Kolby Crouch";
  };
  kolloch = {
    email = "info@eigenvalue.net";
    github = "kolloch";
    githubId = 339354;
    name = "Peter Kolloch";
  };
  konimex = {
    email = "herdiansyah@netc.eu";
    github = "konimex";
    githubId = 15692230;
    name = "Muhammad Herdiansyah";
  };
  koozz = {
    email = "koozz@linux.com";
    github = "koozz";
    githubId = 264372;
    name = "Jan van den Berg";
  };
  koral = {
    email = "koral@mailoo.org";
    github = "k0ral";
    githubId = 524268;
    name = "Koral";
  };
  koslambrou = {
    email = "koslambrou@gmail.com";
    github = "koslambrou";
    githubId = 2037002;
    name = "Konstantinos";
  };
  kototama = {
    email = "kototama@posteo.jp";
    github = "kototama";
    githubId = 128620;
    name = "Kototama";
  };
  kouyk = {
    email = "skykinetic@stevenkou.xyz";
    github = "kouyk";
    githubId = 1729497;
    name = "Steven Kou";
  };
  kovirobi = {
    email = "kovirobi@gmail.com";
    github = "KoviRobi";
    githubId = 1903418;
    name = "Kovacsics Robert";
  };
  kquick = {
    email = "quick@sparq.org";
    github = "kquick";
    githubId = 787421;
    name = "Kevin Quick";
  };
  kradalby = {
    name = "Kristoffer Dalby";
    email = "kristoffer@dalby.cc";
    github = "kradalby";
    githubId = 98431;
  };
  kraem = {
    email = "me@kraem.xyz";
    github = "kraem";
    githubId = 26622971;
    name = "Ronnie Ebrin";
  };
  kragniz = {
    email = "louis@kragniz.eu";
    github = "kragniz";
    githubId = 735008;
    name = "Louis Taylor";
  };
  kranzes = {
    email = "personal@ilanjoselevich.com";
    github = "Kranzes";
    githubId = 56614642;
    name = "Ilan Joselevich";
  };
  krav = {
    email = "kristoffer@microdisko.no";
    github = "krav";
    githubId = 4032;
    name = "Kristoffer Thømt Ravneberg";
  };
  kritnich = {
    email = "kritnich@kritni.ch";
    github = "Kritnich";
    githubId = 22116767;
    name = "Kritnich";
  };
  kroell = {
    email = "nixosmainter@makroell.de";
    github = "rokk4";
    githubId = 17659803;
    name = "Matthias Axel Kröll";
  };
  kristian-brucaj = {
    email = "kbrucaj@gmail.com";
    github = "Kristian-Brucaj";
    githubId = 8893110;
    name = "Kristian Brucaj";
  };
  kristoff3r = {
    email = "k.soeholm@gmail.com";
    github = "kristoff3r";
    githubId = 160317;
    name = "Kristoffer Søholm";
  };
  ktf = {
    email = "giulio.eulisse@cern.ch";
    github = "ktf";
    githubId = 10544;
    name = "Giuluo Eulisse";
  };
  kthielen = {
    email = "kthielen@gmail.com";
    github = "kthielen";
    githubId = 1409287;
    name = "Kalani Thielen";
  };
  ktor = {
    email = "kruszewsky@gmail.com";
    github = "ktor";
    githubId = 99639;
    name = "Pawel Kruszewski";
  };
  kubukoz = {
    email = "kubukoz@gmail.com";
    github = "kubukoz";
    githubId = 894884;
    name = "Jakub Kozłowski";
  };
  kurnevsky = {
    email = "kurnevsky@gmail.com";
    github = "kurnevsky";
    githubId = 2943605;
    name = "Evgeny Kurnevsky";
  };
  kuznero = {
    email = "roman@kuznero.com";
    github = "kuznero";
    githubId = 449813;
    name = "Roman Kuznetsov";
  };
  kwohlfahrt = {
    email = "kai.wohlfahrt@gmail.com";
    github = "kwohlfahrt";
    githubId = 2422454;
    name = "Kai Wohlfahrt";
  };
  kyleondy = {
    email = "kyle@ondy.org";
    github = "KyleOndy";
    githubId = 1640900;
    name = "Kyle Ondy";
    keys = [{
      fingerprint = "3C79 9D26 057B 64E6 D907  B0AC DB0E 3C33 491F 91C9";
    }];
  };
  kylesferrazza = {
    name = "Kyle Sferrazza";
    email = "nixpkgs@kylesferrazza.com";

    github = "kylesferrazza";
    githubId = 6677292;

    keys = [{
      fingerprint = "5A9A 1C9B 2369 8049 3B48  CF5B 81A1 5409 4816 2372";
    }];
  };
  l-as = {
    email = "las@protonmail.ch";
    matrix = "@Las:matrix.org";
    github = "L-as";
    githubId = 22075344;
    keys = [{
      fingerprint = "A093 EA17 F450 D4D1 60A0  1194 AC45 8A7D 1087 D025";
    }];
    name = "Las Safin";
  };
  l3af = {
    email = "L3afMeAlon3@gmail.com";
    matrix = "@L3afMe:matrix.org";
    github = "L3afMe";
    githubId = 72546287;
    name = "L3af";
  };
  laalsaas = {
    email = "laalsaas@systemli.org";
    github = "laalsaas";
    githubId = 43275254;
    name = "laalsaas";
  };
  lach = {
    email = "iam@lach.pw";
    github = "CertainLach";
    githubId = 6235312;
    keys = [{
      fingerprint = "323C 95B5 DBF7 2D74 8570  C0B7 40B5 D694 8143 175F";
    }];
    name = "Yaroslav Bolyukin";
  };
  lafrenierejm = {
    email = "joseph@lafreniere.xyz";
    github = "lafrenierejm";
    githubId = 11155300;
    keys = [{
      fingerprint = "0375 DD9A EDD1 68A3 ADA3  9EBA EE23 6AA0 141E FCA3";
    }];
    name = "Joseph LaFreniere";
  };
  laikq = {
    email = "gwen@quasebarth.de";
    github = "laikq";
    githubId = 55911173;
    name = "Gwendolyn Quasebarth";
  };
  lammermann = {
    email = "k.o.b.e.r@web.de";
    github = "lammermann";
    githubId = 695526;
    name = "Benjamin Kober";
  };
  larsr = {
    email = "Lars.Rasmusson@gmail.com";
    github = "larsr";
    githubId = 182024;
    name = "Lars Rasmusson";
  };
  lasandell = {
    email = "lasandell@gmail.com";
    github = "lasandell";
    githubId = 2034420;
    name = "Luke Sandell";
  };
  lambda-11235 = {
    email = "taranlynn0@gmail.com";
    github = "lambda-11235";
    githubId = 16354815;
    name = "Taran Lynn";
  };
  lassulus = {
    email = "lassulus@gmail.com";
    matrix = "@lassulus:lassul.us";
    github = "Lassulus";
    githubId = 621759;
    name = "Lassulus";
  };
  layus = {
    email = "layus.on@gmail.com";
    github = "layus";
    githubId = 632767;
    name = "Guillaume Maudoux";
  };
  lblasc = {
    email = "lblasc@znode.net";
    github = "lblasc";
    githubId = 32152;
    name = "Luka Blaskovic";
  };
  lbpdt = {
    email = "nix@pdtpartners.com";
    github = "lbpdt";
    githubId = 45168934;
    name = "Louis Blin";
  };
  lucc = {
    email = "lucc+nix@posteo.de";
    github = "lucc";
    githubId = 1104419;
    name = "Lucas Hoffmann";
  };
  lucasew = {
    email = "lucas59356@gmail.com";
    github = "lucasew";
    githubId = 15693688;
    name = "Lucas Eduardo Wendt";
  };
  lde = {
    email = "lilian.deloche@puck.fr";
    github = "lde";
    githubId = 1447020;
    name = "Lilian Deloche";
  };
  ldelelis = {
    email = "ldelelis@est.frba.utn.edu.ar";
    github = "ldelelis";
    githubId = 20250323;
    name = "Lucio Delelis";
  };
  ldenefle = {
    email = "ldenefle@gmail.com";
    github = "ldenefle";
    githubId = 20558127;
    name = "Lucas Denefle";
  };
  ldesgoui = {
    email = "ldesgoui@gmail.com";
    matrix = "@ldesgoui:matrix.org";
    github = "ldesgoui";
    githubId = 2472678;
    name = "Lucas Desgouilles";
  };
  league = {
    email = "league@contrapunctus.net";
    github = "league";
    githubId = 50286;
    name = "Christopher League";
  };
  leahneukirchen = {
    email = "leah@vuxu.org";
    github = "leahneukirchen";
    githubId = 139;
    name = "Leah Neukirchen";
  };
  lebastr = {
    email = "lebastr@gmail.com";
    github = "lebastr";
    githubId = 887072;
    name = "Alexander Lebedev";
  };
  ledif = {
    email = "refuse@gmail.com";
    github = "ledif";
    githubId = 307744;
    name = "Adam Fidel";
  };
  leemachin = {
    email = "me@mrl.ee";
    github = "leemeichin";
    githubId = 736291;
    name = "Lee Machin";
  };
  leenaars = {
    email = "ml.software@leenaa.rs";
    github = "leenaars";
    githubId = 4158274;
    name = "Michiel Leenaars";
  };
  logo = {
    email = "logo4poop@protonmail.com";
    matrix = "@logo4poop:matrix.org";
    github = "logo4poop";
    githubId = 24994565;
    name = "Isaac Silverstein";
  };
  lom = {
    email = "legendofmiracles@protonmail.com";
    matrix = "@legendofmiracles:matrix.org";
    github = "legendofmiracles";
    githubId = 30902201;
    name = "legendofmiracles";
    keys = [{
      fingerprint = "CC50 F82C 985D 2679 0703  AF15 19B0 82B3 DEFE 5451";
    }];
  };
  leifhelm = {
    email = "jakob.leifhelm@gmail.com";
    github = "leifhelm";
    githubId = 31693262;
    name = "Jakob Leifhelm";
    keys =[{
      fingerprint = "4A82 F68D AC07 9FFD 8BF0  89C4 6817 AA02 3810 0822";
    }];
  };
  leixb = {
    email = "abone9999+nixpkgs@gmail.com";
    matrix = "@leix_b:matrix.org";
    github = "Leixb";
    githubId = 17183803;
    name = "Aleix Boné";
    keys = [{
      fingerprint = "63D3 F436 EDE8 7E1F 1292  24AF FC03 5BB2 BB28 E15D";
    }];
  };
  lejonet = {
    email = "daniel@kuehn.se";
    github = "lejonet";
    githubId = 567634;
    name = "Daniel Kuehn";
  };
  leo60228 = {
    email = "leo@60228.dev";
    matrix = "@leo60228:matrix.org";
    github = "leo60228";
    githubId = 8355305;
    name = "leo60228";
    keys = [{
      fingerprint = "5BE4 98D5 1C24 2CCD C21A  4604 AC6F 4BA0 78E6 7833";
    }];
  };
  leona = {
    email = "nix@leona.is";
    github = "leona-ya";
    githubId = 11006031;
    name = "Leona Maroni";
  };
  leonardoce = {
    email = "leonardo.cecchi@gmail.com";
    github = "leonardoce";
    githubId = 1572058;
    name = "Leonardo Cecchi";
  };
  leshainc = {
    email = "leshainc@fomalhaut.me";
    github = "LeshaInc";
    githubId = 42153076;
    name = "Alexey Nikashkin";
  };
  lesuisse = {
    email = "thomas@gerbet.me";
    github = "LeSuisse";
    githubId = 737767;
    name = "Thomas Gerbet";
  };
  lethalman = {
    email = "lucabru@src.gnome.org";
    github = "lethalman";
    githubId = 480920;
    name = "Luca Bruno";
  };
  leungbk = {
    email = "leungbk@mailfence.com";
    github = "leungbk";
    githubId = 29217594;
    name = "Brian Leung";
  };
  lewo = {
    email = "lewo@abesis.fr";
    matrix = "@lewo:matrix.org";
    github = "nlewo";
    githubId = 3425311;
    name = "Antoine Eiche";
  };
  lexuge = {
    name = "Harry Ying";
    email = "lexugeyky@outlook.com";
    github = "LEXUGE";
    githubId = 13804737;
    keys = [{
      fingerprint = "7FE2 113A A08B 695A C8B8  DDE6 AE53 B4C2 E58E DD45";
    }];
  };
  lf- = {
    email = "nix-maint@lfcode.ca";
    github = "lf-";
    githubId = 6652840;
    name = "Jade";
  };
  lgcl = {
    email = "dev@lgcl.de";
    name = "Leon Vack";
    github = "LogicalOverflow";
    githubId = 5919957;
  };
  lheckemann = {
    email = "git@sphalerite.org";
    github = "lheckemann";
    githubId = 341954;
    name = "Linus Heckemann";
  };
  lhvwb = {
    email = "nathaniel.baxter@gmail.com";
    github = "nathanielbaxter";
    githubId = 307589;
    name = "Nathaniel Baxter";
  };
  liamdiprose = {
    email = "liam@liamdiprose.com";
    github = "liamdiprose";
    githubId = 1769386;
    name = "Liam Diprose";
  };
  libjared = {
    email = "jared@perrycode.com";
    github = "libjared";
    githubId = 3746656;
    matrix = "@libjared:matrix.org";
    name = "Jared Perry";
  };
  liff = {
    email = "liff@iki.fi";
    github = "liff";
    githubId = 124475;
    name = "Olli Helenius";
  };
  lightbulbjim = {
    email = "chris@killred.net";
    github = "lightbulbjim";
    githubId = 4312404;
    name = "Chris Rendle-Short";
  };
  lightdiscord = {
    email = "root@arnaud.sh";
    github = "lightdiscord";
    githubId = 24509182;
    name = "Arnaud Pascal";
  };
  lightquantum = {
    email = "self@lightquantum.me";
    github = "PhotonQuantum";
    githubId = 18749973;
    name = "Yanning Chen";
    matrix = "@self:lightquantum.me";
  };
  lihop = {
    email = "nixos@leroy.geek.nz";
    github = "lihop";
    githubId = 3696783;
    name = "Leroy Hopson";
  };
  lilyball = {
    email = "lily@sb.org";
    github = "lilyball";
    githubId = 714;
    name = "Lily Ballard";
  };
  lilyinstarlight = {
    email = "lily@lily.flowers";
    matrix = "@lily:lily.flowers";
    github = "lilyinstarlight";
    githubId = 298109;
    name = "Lily Foster";
  };
  limeytexan = {
    email = "limeytexan@gmail.com";
    github = "limeytexan";
    githubId = 36448130;
    name = "Michael Brantley";
  };
  linc01n = {
    email = "git@lincoln.hk";
    github = "linc01n";
    githubId = 667272;
    name = "Lincoln Lee";
  };
  linj = {
    name = "Lin Jian";
    email = "me@linj.tech";
    matrix = "@me:linj.tech";
    github = "jian-lin";
    githubId = 75130626;
    keys = [{
      fingerprint = "80EE AAD8 43F9 3097 24B5  3D7E 27E9 7B91 E63A 7FF8";
    }];
  };
  linquize = {
    email = "linquize@yahoo.com.hk";
    github = "linquize";
    githubId = 791115;
    name = "Linquize";
  };
  linsui = {
    email = "linsui555@gmail.com";
    github = "linsui";
    githubId = 36977733;
    name = "linsui";
  };
  linus = {
    email = "linusarver@gmail.com";
    github = "listx";
    githubId = 725613;
    name = "Linus Arver";
  };
  livnev = {
    email = "lev@liv.nev.org.uk";
    github = "livnev";
    githubId = 3964494;
    name = "Lev Livnev";
    keys = [{
      fingerprint = "74F5 E5CC 19D3 B5CB 608F  6124 68FF 81E6 A785 0F49";
    }];
  };
  lourkeur = {
    name = "Louis Bettens";
    email = "louis@bettens.info";
    github = "lourkeur";
    githubId = 15657735;
    keys = [{
      fingerprint = "5B93 9CFA E8FC 4D8F E07A  3AEA DFE1 D4A0 1733 7E2A";
    }];
  };
  lorenzleutgeb = {
    email = "lorenz@leutgeb.xyz";
    github = "lorenzleutgeb";
    githubId = 542154;
    name = "Lorenz Leutgeb";
  };
  luis = {
    email = "luis.nixos@gmail.com";
    github = "Luis-Hebendanz";
    githubId = 22085373;
    name = "Luis Hebendanz";
  };
  luizribeiro = {
    email = "nixpkgs@l9o.dev";
    matrix = "@luizribeiro:matrix.org";
    name = "Luiz Ribeiro";
    github = "luizribeiro";
    githubId = 112069;
    keys = [{
      fingerprint = "97A0 AE5E 03F3 499B 7D7A  65C6 76A4 1432 37EF 5817";
    }];
  };
  lunarequest = {
    email = "nullarequest@vivlaid.net";
    github = "Lunarequest";
    githubId = 30698906;
    name = "Luna D Dragon";
  };
  LunNova = {
    email = "nixpkgs-maintainer@lunnova.dev";
    github = "LunNova";
    githubId = 782440;
    name = "Luna Nova";
  };
  lionello = {
    email = "lio@lunesu.com";
    github = "lionello";
    githubId = 591860;
    name = "Lionello Lunesu";
  };
  lluchs = {
    email = "lukas.werling@gmail.com";
    github = "lluchs";
    githubId = 516527;
    name = "Lukas Werling";
  };
  lnl7 = {
    email = "daiderd@gmail.com";
    github = "LnL7";
    githubId = 689294;
    name = "Daiderd Jordan";
  };
  lo1tuma = {
    email = "schreck.mathias@gmail.com";
    github = "lo1tuma";
    githubId = 169170;
    name = "Mathias Schreck";
  };
  loewenheim = {
    email = "loewenheim@mailbox.org";
    github = "loewenheim";
    githubId = 7622248;
    name = "Sebastian Zivota";
  };
  locallycompact = {
    email = "dan.firth@homotopic.tech";
    github = "locallycompact";
    githubId = 1267527;
    name = "Daniel Firth";
  };
  lockejan = {
    email = "git@smittie.de";
    matrix = "@jan:smittie.de";
    github = "lockejan";
    githubId = 25434434;
    name = "Jan Schmitt";
    keys = [{
      fingerprint = "1763 9903 2D7C 5B82 5D5A  0EAD A2BC 3C6F 1435 1991";
    }];
  };
  lodi = {
    email = "anthony.lodi@gmail.com";
    github = "lodi";
    githubId = 918448;
    name = "Anthony Lodi";
  };
  loicreynier = {
    email = "loic@loicreynier.fr";
    github = "loicreynier";
    githubId = 88983487;
    name = "Loïc Reynier";
  };
  lopsided98 = {
    email = "benwolsieffer@gmail.com";
    github = "lopsided98";
    githubId = 5624721;
    name = "Ben Wolsieffer";
  };
  loskutov = {
    email = "ignat.loskutov@gmail.com";
    github = "loskutov";
    githubId = 1202012;
    name = "Ignat Loskutov";
  };
  lostnet = {
    email = "lost.networking@gmail.com";
    github = "lostnet";
    githubId = 1422781;
    name = "Will Young";
  };
  louisdk1 = {
    email = "louis@louis.dk";
    github = "LouisDK1";
    githubId = 4969294;
    name = "Louis Tim Larsen";
  };
  lovek323 = {
    email = "jason@oconal.id.au";
    github = "lovek323";
    githubId = 265084;
    name = "Jason O'Conal";
  };
  lovesegfault = {
    email = "meurerbernardo@gmail.com";
    matrix = "@lovesegfault:matrix.org";
    github = "lovesegfault";
    githubId = 7243783;
    name = "Bernardo Meurer";
    keys = [{
      fingerprint = "F193 7596 57D5 6DA4 CCD4  786B F4C0 D53B 8D14 C246";
    }];
  };
  lowfatcomputing = {
    email = "andreas.wagner@lowfatcomputing.org";
    github = "lowfatcomputing";
    githubId = 10626;
    name = "Andreas Wagner";
  };
  lrewega = {
    email = "lrewega@c32.ca";
    github = "lrewega";
    githubId = 639066;
    name = "Luke Rewega";
  };
  lromor = {
    email = "leonardo.romor@gmail.com";
    github = "lromor";
    githubId = 1597330;
    name = "Leonardo Romor";
  };
  lschuermann = {
    email = "leon.git@is.currently.online";
    matrix = "@leons:is.currently.online";
    github = "lschuermann";
    githubId = 5341193;
    name = "Leon Schuermann";
  };
  lsix = {
    email = "lsix@lancelotsix.com";
    github = "lsix";
    githubId = 724339;
    name = "Lancelot SIX";
  };
  ltavard = {
    email = "laure.tavard@univ-grenoble-alpes.fr";
    github = "ltavard";
    githubId = 8555953;
    name = "Laure Tavard";
  };
  luc65r = {
    email = "lucas@ransan.tk";
    github = "luc65r";
    githubId = 59375051;
    name = "Lucas Ransan";
  };
  lucperkins = {
    email = "lucperkins@gmail.com";
    github = "lucperkins";
    githubId = 1523104;
    name = "Luc Perkins";
  };
  lucus16 = {
    email = "lars.jellema@gmail.com";
    github = "Lucus16";
    githubId = 2487922;
    name = "Lars Jellema";
  };
  ludo = {
    email = "ludo@gnu.org";
    github = "civodul";
    githubId = 1168435;
    name = "Ludovic Courtès";
  };
  lufia = {
    email = "lufia@lufia.org";
    github = "lufia";
    githubId = 1784379;
    name = "Kyohei Kadota";
  };
  Luflosi = {
    name = "Luflosi";
    email = "luflosi@luflosi.de";
    github = "Luflosi";
    githubId = 15217907;
    keys = [{
      fingerprint = "66D1 3048 2B5F 2069 81A6  6B83 6F98 7CCF 224D 20B9";
    }];
  };
  luispedro = {
    email = "luis@luispedro.org";
    github = "luispedro";
    githubId = 79334;
    name = "Luis Pedro Coelho";
  };
  lukeadams = {
    email = "luke.adams@belljar.io";
    github = "lukeadams";
    githubId = 3508077;
    name = "Luke Adams";
  };
  lukebfox = {
    email = "lbentley-fox1@sheffield.ac.uk";
    github = "lukebfox";
    githubId = 34683288;
    name = "Luke Bentley-Fox";
  };
  lukegb = {
    email = "nix@lukegb.com";
    matrix = "@lukegb:zxcvbnm.ninja";
    github = "lukegb";
    githubId = 246745;
    name = "Luke Granger-Brown";
  };
  lukego = {
    email = "luke@snabb.co";
    github = "lukego";
    githubId = 13791;
    name = "Luke Gorrie";
  };
  luker = {
    email = "luker@fenrirproject.org";
    github = "LucaFulchir";
    githubId = 2486026;
    name = "Luca Fulchir";
  };
  lumi = {
    email = "lumi@pew.im";
    github = "lumi-me-not";
    githubId = 26020062;
    name = "lumi";
  };
  lunik1 = {
    email = "ch.nixpkgs@themaw.xyz";
    matrix = "@lunik1:lunik.one";
    github = "lunik1";
    githubId = 13547699;
    name = "Corin Hoad";
    keys = [{
      fingerprint = "BA3A 5886 AE6D 526E 20B4  57D6 6A37 DF94 8318 8492";
    }];
  };
  lux = {
    email = "lux@lux.name";
    github = "luxferresum";
    githubId = 1208273;
    matrix = "@lux:ontheblueplanet.com";
    name = "Lux";
  };
  luz = {
    email = "luz666@daum.net";
    github = "Luz";
    githubId = 208297;
    name = "Luz";
  };
  lw = {
    email = "lw@fmap.me";
    github = "lolwat97";
    githubId = 2057309;
    name = "Sergey Sofeychuk";
  };
  lxea = {
    email = "nix@amk.ie";
    github = "lxea";
    githubId = 7910815;
    name = "Alex McGrath";
  };
  lynty = {
    email = "ltdong93+nix@gmail.com";
    github = "Lynty";
    githubId = 39707188;
    name = "Lynn Dong";
  };
  m00wl = {
    name = "Moritz Lumme";
    email = "moritz.lumme@gmail.com";
    github = "m00wl";
    githubId = 46034439;
  };
  m1cr0man = {
    email = "lucas+nix@m1cr0man.com";
    github = "m1cr0man";
    githubId = 3044438;
    name = "Lucas Savva";
  };
  ma27 = {
    email = "maximilian@mbosch.me";
    matrix = "@ma27:nicht-so.sexy";
    github = "Ma27";
    githubId = 6025220;
    name = "Maximilian Bosch";
  };
  ma9e = {
    email = "sean@lfo.team";
    github = "furrycatherder";
    githubId = 36235154;
    name = "Sean Haugh";
  };
  maaslalani = {
    email = "maaslalani0@gmail.com";
    github = "maaslalani";
    githubId = 42545625;
    name = "Maas Lalani";
  };
  maddiethecafebabe = {
    email = "maddie@cafebabe.date";
    github = "maddiethecafebabe";
    githubId = 75337286;
    name = "Madeline S.";
  };
  madjar = {
    email = "georges.dubus@compiletoi.net";
    github = "madjar";
    githubId = 109141;
    name = "Georges Dubus";
  };
  madonius = {
    email = "nixos@madoni.us";
    github = "madonius";
    githubId = 1246752;
    name = "madonius";
    matrix = "@madonius:entropia.de";
  };
  Madouura = {
    email = "madouura@gmail.com";
    github = "Madouura";
    githubId = 93990818;
    name = "Madoura";
  };
  mafo = {
    email = "Marc.Fontaine@gmx.de";
    github = "MarcFontaine";
    githubId = 1433367;
    name = "Marc Fontaine";
  };
  magenbluten = {
    email = "magenbluten@codemonkey.cc";
    github = "magenbluten";
    githubId = 1140462;
    name = "magenbluten";
  };
  magnetophon = {
    email = "bart@magnetophon.nl";
    github = "magnetophon";
    githubId = 7645711;
    name = "Bart Brouns";
  };
  magnouvean = {
    email = "rg0zjsyh@anonaddy.me";
    github = "magnouvean";
    githubId = 85435692;
    name = "Maxwell Berg";
  };
  mahe = {
    email = "matthias.mh.herrmann@gmail.com";
    github = "2chilled";
    githubId = 1238350;
    name = "Matthias Herrmann";
  };
  majesticmullet = {
    email = "hoccthomas@gmail.com.au";
    github = "MajesticMullet";
    githubId = 31056089;
    name = "Tom Ho";
  };
  majewsky = {
    email = "majewsky@gmx.net";
    github = "majewsky";
    githubId = 24696;
    name = "Stefan Majewsky";
  };
  majiir = {
    email = "majiir@nabaal.net";
    github = "Majiir";
    githubId = 963511;
    name = "Majiir Paktu";
  };
  makefu = {
    email = "makefu@syntax-fehler.de";
    github = "makefu";
    githubId = 115218;
    name = "Felix Richter";
  };
  malo = {
    email = "mbourgon@gmail.com";
    github = "malob";
    githubId = 2914269;
    name = "Malo Bourgon";
  };
  malvo = {
    email = "malte@malvo.org";
    github = "malte-v";
    githubId = 34393802;
    name = "Malte Voos";
  };
  malbarbo = {
    email = "malbarbo@gmail.com";
    github = "malbarbo";
    githubId = 1678126;
    name = "Marco A L Barbosa";
  };
  malyn = {
    email = "malyn@strangeGizmo.com";
    github = "malyn";
    githubId = 346094;
    name = "Michael Alyn Miller";
  };
  manojkarthick = {
    email = "smanojkarthick@gmail.com";
    github = "manojkarthick";
    githubId = 7802795;
    name = "Manoj Karthick";
  };
  manveru = {
    email = "m.fellinger@gmail.com";
    matrix = "@manveru:matrix.org";
    github = "manveru";
    githubId = 3507;
    name = "Michael Fellinger";
  };
  maralorn = {
    email = "mail@maralorn.de";
    matrix = "@maralorn:maralorn.de";
    github = "maralorn";
    githubId = 1651325;
    name = "maralorn";
  };
  marcweber = {
    email = "marco-oweber@gmx.de";
    github = "MarcWeber";
    githubId = 34086;
    name = "Marc Weber";
  };
  marcus7070 = {
    email = "marcus@geosol.com.au";
    github = "marcus7070";
    githubId = 50230945;
    name = "Marcus Boyd";
  };
  marenz = {
    email = "marenz@arkom.men";
    github = "marenz2569";
    githubId = 12773269;
    name = "Markus Schmidl";
  };
  markus1189 = {
    email = "markus1189@gmail.com";
    github = "markus1189";
    githubId = 591567;
    name = "Markus Hauck";
  };
  markuskowa = {
    email = "markus.kowalewski@gmail.com";
    github = "markuskowa";
    githubId = 26470037;
    name = "Markus Kowalewski";
  };
  mariaa144 = {
    email = "speechguard_intensivist@aleeas.com";
    github = "mariaa144";
    githubId = 105451387;
    name = "Maria";
  };
  marijanp = {
    name = "Marijan Petričević";
    email = "marijan.petricevic94@gmail.com";
    github = "marijanp";
    githubId = 13599169;
  };
  marius851000 = {
    email = "mariusdavid@laposte.net";
    name = "Marius David";
    github = "marius851000";
    githubId = 22586596;
  };
  marsam = {
    email = "marsam@users.noreply.github.com";
    github = "marsam";
    githubId = 65531;
    name = "Mario Rodas";
  };
  marsupialgutz = {
    email = "mars@possums.xyz";
    github = "pupbrained";
    githubId = 33522919;
    name = "Marshall Arruda";
  };
  martijnvermaat = {
    email = "martijn@vermaat.name";
    github = "martijnvermaat";
    githubId = 623509;
    name = "Martijn Vermaat";
  };
  martinetd = {
    email = "f.ktfhrvnznqxacf@noclue.notk.org";
    github = "martinetd";
    githubId = 1729331;
    name = "Dominique Martinet";
  };
  martingms = {
    email = "martin@mg.am";
    github = "martingms";
    githubId = 458783;
    name = "Martin Gammelsæter";
  };
  martfont = {
    name = "Martino Fontana";
    email = "tinozzo123@tutanota.com";
    github = "SuperSamus";
    githubId = 40663462;
  };
  marzipankaiser = {
    email = "nixos@gaisseml.de";
    github = "marzipankaiser";
    githubId = 2551444;
    name = "Marcial Gaißert";
    keys = [{
      fingerprint = "B573 5118 0375 A872 FBBF  7770 B629 036B E399 EEE9";
    }];
  };
  masipcat = {
    email = "jordi@masip.cat";
    github = "masipcat";
    githubId = 775189;
    name = "Jordi Masip";
  };
  MaskedBelgian = {
    email = "michael.colicchia@imio.be";
    github = "MaskedBelgian";
    githubId = 29855073;
    name = "Michael Colicchia";
  };
  matejc = {
    email = "cotman.matej@gmail.com";
    github = "matejc";
    githubId = 854770;
    name = "Matej Cotman";
  };
  mathnerd314 = {
    email = "mathnerd314.gph+hs@gmail.com";
    github = "Mathnerd314";
    githubId = 322214;
    name = "Mathnerd314";
  };
  math-42 = {
    email = "matheus.4200@gmail.com";
    github = "Math-42";
    githubId = 43853194;
    name = "Matheus Vieira";
  };
  matklad = {
    email = "aleksey.kladov@gmail.com";
    github = "matklad";
    githubId = 1711539;
    name = "matklad";
  };
  matrss = {
    name = "Matthias Riße";
    email = "matthias.risze@t-online.de";
    github = "matrss";
    githubId = 9308656;
  };
  matt-snider = {
    email = "matt.snider@protonmail.com";
    github = "matt-snider";
    githubId = 11810057;
    name = "Matt Snider";
  };
  mattchrist = {
    email = "nixpkgs-matt@christ.systems";
    github = "mattchrist";
    githubId = 952712;
    name = "Matt Christ";
  };
  matthewbauer = {
    email = "mjbauer95@gmail.com";
    github = "matthewbauer";
    githubId = 19036;
    name = "Matthew Bauer";
  };
  matthiasbenaets = {
    email = "matthias.benaets@gmail.com";
    github = "MatthiasBenaets";
    githubId = 89214559;
    name = "Matthias Benaets";
  };
  matthiasbeyer = {
    email = "mail@beyermatthias.de";
    matrix = "@musicmatze:beyermatthi.as";
    github = "matthiasbeyer";
    githubId = 427866;
    name = "Matthias Beyer";
  };
  MatthieuBarthel = {
    email = "matthieu@imatt.ch";
    name = "Matthieu Barthel";
    github = "MatthieuBarthel";
    githubId = 435534;
    keys = [{
      fingerprint = "80EB 0F2B 484A BB80 7BEF  4145 BA23 F10E AADC 2E26";
    }];
  };
  matthuszagh = {
    email = "huszaghmatt@gmail.com";
    github = "matthuszagh";
    githubId = 7377393;
    name = "Matt Huszagh";
  };
  matti-kariluoma = {
    email = "matti@kariluo.ma";
    github = "matti-kariluoma";
    githubId = 279868;
    name = "Matti Kariluoma";
  };
  matthewpi = {
    email = "me+nix@matthewp.io";
    github = "matthewpi";
    githubId = 26559841;
    name = "Matthew Penner";
    keys = [{
      fingerprint = "5118 F1CC B7B0 6C17 4DD1  5267 3131 1906 AD4C F6D6";
    }];
  };
  maurer = {
    email = "matthew.r.maurer+nix@gmail.com";
    github = "maurer";
    githubId = 136037;
    name = "Matthew Maurer";
  };
  mausch = {
    email = "mauricioscheffer@gmail.com";
    github = "mausch";
    githubId = 95194;
    name = "Mauricio Scheffer";
  };
  maxhero = {
    email = "contact@maxhero.dev";
    github = "themaxhero";
    githubId = 4708337;
    name = "Marcelo A. de L. Santos";
  };
  max-niederman = {
    email = "max@maxniederman.com";
    github = "max-niederman";
    githubId = 19580458;
    name = "Max Niederman";
    keys = [{
      fingerprint = "1DE4 424D BF77 1192 5DC4  CF5E 9AED 8814 81D8 444E";
    }];
  };
   maxbrunet = {
    email = "max@brnt.mx";
    github = "maxbrunet";
    githubId = 32458727;
    name = "Maxime Brunet";
    keys = [{
      fingerprint = "E9A2 EE26 EAC6 B3ED 6C10  61F3 4379 62FF 87EC FE2B";
    }];
  };
  maxdamantus = {
    email = "maxdamantus@gmail.com";
    github = "Maxdamantus";
    githubId = 502805;
    name = "Max Zerzouri";
  };
  maxeaubrey = {
    email = "maxeaubrey@gmail.com";
    github = "maxeaubrey";
    githubId = 35892750;
    name = "Maxine Aubrey";
  };
  maxhille = {
    email = "mh@lambdasoup.com";
    github = "maxhille";
    githubId = 693447;
    name = "Max Hille";
  };
  maxhbr = {
    email = "nixos@maxhbr.dev";
    github = "maxhbr";
    githubId = 1187050;
    name = "Maximilian Huber";
  };
  maximsmol = {
    email = "maximsmol@gmail.com";
    github = "maximsmol";
    githubId = 1472826;
    name = "Max Smolin";
  };
  maxux = {
    email = "root@maxux.net";
    github = "maxux";
    githubId = 4141584;
    name = "Maxime Daniel";
  };
  maxwell-lt = {
    email = "maxwell.lt@live.com";
    github = "maxwell-lt";
    githubId = 17859747;
    name = "Maxwell L-T";
  };
  maxxk = {
    email = "maxim.krivchikov@gmail.com";
    github = "maxxk";
    githubId = 1191859;
    name = "Maxim Krivchikov";
  };
  MayNiklas = {
    email = "info@niklas-steffen.de";
    github = "MayNiklas";
    githubId = 44636701;
    name = "Niklas Steffen";
  };
  mazurel = {
    email = "mateusz.mazur@yahoo.com";
    github = "Mazurel";
    githubId = 22836301;
    name = "Mateusz Mazur";
  };
  mbaeten = {
    email = "mbaeten@users.noreply.github.com";
    github = "mbaeten";
    githubId = 2649304;
    name = "M. Baeten";
  };
  mbaillie = {
    email = "martin@baillie.id";
    github = "martinbaillie";
    githubId = 613740;
    name = "Martin Baillie";
  };
  mbbx6spp = {
    email = "me@susanpotter.net";
    github = "mbbx6spp";
    githubId = 564;
    name = "Susan Potter";
  };
  mbe = {
    email = "brandonedens@gmail.com";
    github = "brandonedens";
    githubId = 396449;
    name = "Brandon Edens";
  };
  mbode = {
    email = "maxbode@gmail.com";
    github = "mbode";
    githubId = 9051309;
    name = "Maximilian Bode";
  };
  mboes = {
    email = "mboes@tweag.net";
    github = "mboes";
    githubId = 51356;
    name = "Mathieu Boespflug";
  };
  mbprtpmnr = {
    name = "mbprtpmnr";
    email = "mbprtpmnr@pm.me";
    github = "mbprtpmnr";
    githubId = 88109321;
  };
  mbrgm = {
    email = "marius@yeai.de";
    github = "mbrgm";
    githubId = 2971615;
    name = "Marius Bergmann";
  };
  mcaju = {
    email = "cajum.bugs@yandex.com";
    github = "CajuM";
    githubId = 10420834;
    name = "Mihai-Drosi Caju";
  };
  mcbeth = {
    email = "mcbeth@broggs.org";
    github = "mcbeth";
    githubId = 683809;
    name = "Jeffrey Brent McBeth";
  };
  mcmtroffaes = {
    email = "matthias.troffaes@gmail.com";
    github = "mcmtroffaes";
    githubId = 158568;
    name = "Matthias C. M. Troffaes";
  };
  McSinyx = {
    email = "mcsinyx@disroot.org";
    github = "McSinyx";
    githubId = 13689192;
    name = "Nguyễn Gia Phong";
    keys = [{
      fingerprint = "E90E 11B8 0493 343B 6132  E394 2714 8B2C 06A2 224B";
    }];
  };
  mcwitt = {
    email = "mcwitt@gmail.com";
    github = "mcwitt";
    githubId = 319411;
    name = "Matt Wittmann";
  };
  mdaiter = {
    email = "mdaiter8121@gmail.com";
    github = "mdaiter";
    githubId = 1377571;
    name = "Matthew S. Daiter";
  };
  mdarocha = {
    email = "marek@mdarocha.pl";
    github = "mdarocha";
    githubId = 11572618;
    name = "Marek Darocha";
  };
  mdevlamynck = {
    email = "matthias.devlamynck@mailoo.org";
    github = "mdevlamynck";
    githubId = 4378377;
    name = "Matthias Devlamynck";
  };
  mdlayher = {
    email = "mdlayher@gmail.com";
    github = "mdlayher";
    githubId = 1926905;
    name = "Matt Layher";
    keys = [{
      fingerprint = "D709 03C8 0BE9 ACDC 14F0  3BFB 77BF E531 397E DE94";
    }];
  };
  meain = {
    email = "mail@meain.io";
    matrix = "@meain:matrix.org";
    github = "meain";
    githubId = 14259816;
    name = "Abin Simon";
  };
  meatcar = {
    email = "nixpkgs@denys.me";
    github = "meatcar";
    githubId = 191622;
    name = "Denys Pavlov";
  };
  meditans = {
    email = "meditans@gmail.com";
    github = "meditans";
    githubId = 4641445;
    name = "Carlo Nucera";
  };
  megheaiulian = {
    email = "iulian.meghea@gmail.com";
    github = "megheaiulian";
    githubId = 1788114;
    name = "Meghea Iulian";
  };
  meisternu = {
    email = "meister@krutt.org";
    github = "meisternu";
    githubId = 8263431;
    name = "Matt Miemiec";
  };
  melchips = {
    email = "truphemus.francois@gmail.com";
    github = "melchips";
    githubId = 365721;
    name = "Francois Truphemus";
  };
  melsigl = {
    email = "melanie.bianca.sigl@gmail.com";
    github = "melsigl";
    githubId = 15093162;
    name = "Melanie B. Sigl";
  };
  melkor333 = {
    email = "samuel@ton-kunst.ch";
    github = "Melkor333";
    githubId = 6412377;
    name = "Samuel Ruprecht";
  };
  kira-bruneau = {
    email = "kira.bruneau@pm.me";
    name = "Kira Bruneau";
    github = "kira-bruneau";
    githubId = 382041;
  };
  mephistophiles = {
    email = "mussitantesmortem@gmail.com";
    name = "Maxim Zhukov";
    github = "Mephistophiles";
    githubId = 4850908;
  };
  mfossen = {
    email = "msfossen@gmail.com";
    github = "mfossen";
    githubId = 3300322;
    name = "Mitchell Fossen";
  };
  mgdelacroix = {
    email = "mgdelacroix@gmail.com";
    github = "mgdelacroix";
    githubId = 223323;
    name = "Miguel de la Cruz";
  };
  mgdm = {
    email = "michael@mgdm.net";
    github = "mgdm";
    githubId = 71893;
    name = "Michael Maclean";
  };
  mglolenstine = {
    email = "mglolenstine@gmail.com";
    github = "MGlolenstine";
    githubId = 9406770;
    matrix = "@mglolenstine:matrix.org";
    name = "MGlolenstine";
  };
  mgregoire = {
    email = "gregoire@martinache.net";
    github = "M-Gregoire";
    githubId = 9469313;
    name = "Gregoire Martinache";
  };
  mgttlinger = {
    email = "megoettlinger@gmail.com";
    github = "mgttlinger";
    githubId = 5120487;
    name = "Merlin Humml";
  };
  mguentner = {
    email = "code@klandest.in";
    github = "mguentner";
    githubId = 668926;
    name = "Maximilian Güntner";
  };
  mh = {
    email = "68288772+markus-heinrich@users.noreply.github.com";
    github = "markus-heinrich";
    githubId = 68288772;
    name = "Markus Heinrich";
  };
  mhaselsteiner = {
    email = "magdalena.haselsteiner@gmx.at";
    github = "mhaselsteiner";
    githubId = 20536514;
    name = "Magdalena Haselsteiner";
  };
  mh182 = {
    email = "mh182@chello.at";
    github = "mh182";
    githubId = 9980864;
    name = "Max Hofer";
  };
  miangraham = {
    email = "miangraham@users.noreply.github.com";
    github = "miangraham";
    githubId = 704580;
    name = "M. Ian Graham";
    keys = [{
      fingerprint = "8CE3 2906 516F C4D8 D373  308A E189 648A 55F5 9A9F";
    }];
  };
  mic92 = {
    email = "joerg@thalheim.io";
    matrix = "@mic92:nixos.dev";
    github = "Mic92";
    githubId = 96200;
    name = "Jörg Thalheim";
    keys = [{
      # compare with https://keybase.io/Mic92
      fingerprint = "3DEE 1C55 6E1C 3DC5 54F5  875A 003F 2096 411B 5F92";
    }];
  };
  michaeladler = {
    email = "therisen06@gmail.com";
    github = "michaeladler";
    githubId = 1575834;
    name = "Michael Adler";
  };
  michaelBelsanti = {
    email = "mbels03@protonmail.com";
    name = "Mike Belsanti";
    github = "michaelBelsanti";
    githubId = 62124625;
  };
  michaelpj = {
    email = "michaelpj@gmail.com";
    github = "michaelpj";
    githubId = 1699466;
    name = "Michael Peyton Jones";
  };
  michalrus = {
    email = "m@michalrus.com";
    github = "michalrus";
    githubId = 4366292;
    name = "Michal Rus";
  };
  michelk = {
    email = "michel@kuhlmanns.info";
    github = "michelk";
    githubId = 1404919;
    name = "Michel Kuhlmann";
  };
  michojel = {
    email = "mic.liamg@gmail.com";
    github = "michojel";
    githubId = 21156022;
    name = "Michal Minář";
  };
  michzappa = {
    email = "me@michzappa.com";
    github = "michzappa";
    githubId = 59343378;
    name = "Michael Zappa";
  };
  mickours = {
    email = "mickours@gmail.com<";
    github = "mickours";
    githubId = 837312;
    name = "Michael Mercier";
  };
  midchildan = {
    email = "git@midchildan.org";
    matrix = "@midchildan:matrix.org";
    github = "midchildan";
    githubId = 7343721;
    name = "midchildan";
    keys = [{
      fingerprint = "FEF0 AE2D 5449 3482 5F06  40AA 186A 1EDA C5C6 3F83";
    }];
  };
  mightyiam = {
    email = "mightyiampresence@gmail.com";
    github = "mightyiam";
    githubId = 635591;
    name = "Shahar Dawn Or";
  };
  mihnea-s = {
    email = "mihn.stn@gmail.com";
    github = "mihnea-s";
    githubId = 43088426;
    name = "Mihnea Stoian";
  };
  mikefaille = {
    email = "michael@faille.io";
    github = "mikefaille";
    githubId = 978196;
    name = "Michaël Faille";
  };
  mikoim = {
    email = "ek@esh.ink";
    github = "mikoim";
    githubId = 3958340;
    name = "Eshin Kunishima";
  };
  mikesperber = {
    email = "sperber@deinprogramm.de";
    github = "mikesperber";
    githubId = 1387206;
    name = "Mike Sperber";
  };
  mikroskeem = {
    email = "mikroskeem@mikroskeem.eu";
    github = "mikroskeem";
    githubId = 3490861;
    name = "Mark Vainomaa";
    keys = [{
      fingerprint = "DB43 2895 CF68 F0CE D4B7  EF60 DA01 5B05 B5A1 1B22";
    }];
  };
  milahu = {
    email = "milahu@gmail.com";
    github = "milahu";
    githubId = 12958815;
    name = "Milan Hauth";
  };
  milesbreslin = {
    email = "milesbreslin@gmail.com";
    github = "MilesBreslin";
    githubId = 38543128;
    name = "Miles Breslin";
  };
  milibopp = {
    email = "contact@ebopp.de";
    github = "milibopp";
    githubId = 3098430;
    name = "Emilia Bopp";
  };
  millerjason = {
    email = "mailings-github@millerjason.com";
    github = "millerjason";
    githubId = 7610974;
    name = "Jason Miller";
  };
  milogert = {
    email = "milo@milogert.com";
    github = "milogert";
    githubId = 5378535;
    name = "Milo Gertjejansen";
  };
  mimame = {
    email = "miguel.madrid.mencia@gmail.com";
    github = "mimame";
    githubId = 3269878;
    name = "Miguel Madrid Mencía";
  };
  mindavi = {
    email = "rol3517@gmail.com";
    github = "Mindavi";
    githubId = 9799623;
    name = "Rick van Schijndel";
  };
  minijackson = {
    email = "minijackson@riseup.net";
    github = "minijackson";
    githubId = 1200507;
    name = "Rémi Nicole";
    keys = [{
      fingerprint = "3196 83D3 9A1B 4DE1 3DC2  51FD FEA8 88C9 F5D6 4F62";
    }];
  };
  minion3665 = {
    name = "Skyler Grey";
    email = "skyler3665@gmail.com";
    matrix = "@minion3665:matrix.org";
    github = "Minion3665";
    githubId = 34243578;
    keys = [{
      fingerprint = "D520 AC8D 7C96 9212 5B2B  BD3A 1AFD 1025 6B3C 714D";
    }];
  };
  mir06 = {
    email = "armin.leuprecht@uni-graz.at";
    github = "mir06";
    githubId = 8479244;
    name = "Armin Leuprecht";
  };
  mirdhyn = {
    email = "mirdhyn@gmail.com";
    github = "mirdhyn";
    githubId = 149558;
    name = "Merlin Gaillard";
  };
  mirrexagon = {
    email = "mirrexagon@mirrexagon.com";
    github = "mirrexagon";
    githubId = 1776903;
    name = "Andrew Abbott";
  };
  mislavzanic = {
    email = "mislavzanic3@gmail.com";
    github = "mislavzanic";
    githubId = 48838244;
    name = "Mislav Zanic";
  };
  misterio77 = {
    email = "eu@misterio.me";
    github = "Misterio77";
    githubId = 5727578;
    matrix = "@misterio:matrix.org";
    name = "Gabriel Fontes";
    keys = [{
      fingerprint = "7088 C742 1873 E0DB 97FF  17C2 245C AB70 B4C2 25E9";
    }];
  };
  mitchmindtree = {
    email = "mail@mitchellnordine.com";
    github = "mitchmindtree";
    githubId = 4587373;
    name = "Mitchell Nordine";
  };
  mjanczyk = {
    email = "m@dragonvr.pl";
    github = "mjanczyk";
    githubId = 1001112;
    name = "Marcin Janczyk";
  };
  mjp = {
    email = "mike@mythik.co.uk";
    github = "MikePlayle";
    githubId = 16974598;
    name = "Mike Playle";
  };
  mkaito = {
    email = "chris@mkaito.net";
    github = "mkaito";
    githubId = 20434;
    name = "Christian Höppner";
  };
  mkazulak = {
    email = "kazulakm@gmail.com";
    github = "mulderr";
    githubId = 5698461;
    name = "Maciej Kazulak";
  };
  mkf = {
    email = "m@mikf.pl";
    github = "mkf";
    githubId = 7753506;
    name = "Michał Krzysztof Feiler";
    keys = [{
      fingerprint = "1E36 9940 CC7E 01C4 CFE8  F20A E35C 2D7C 2C6A C724";
    }];
  };
  mkg = {
    email = "mkg@vt.edu";
    github = "mkgvt";
    githubId = 22477669;
    name = "Mark K Gardner";
  };
  mkg20001 = {
    email = "mkg20001+nix@gmail.com";
    matrix = "@mkg20001:matrix.org";
    github = "mkg20001";
    githubId = 7735145;
    name = "Maciej Krüger";
    keys = [{
      fingerprint = "E90C BA34 55B3 6236 740C  038F 0D94 8CE1 9CF4 9C5F";
    }];
  };
  mktip = {
    email = "mo.issa.ok+nix@gmail.com";
    github = "mktip";
    githubId = 45905717;
    name = "Mohammad Issa";
    keys = [{
      fingerprint = "64BE BF11 96C3 DD7A 443E  8314 1DC0 82FA DE5B A863";
    }];
  };
  mlieberman85 = {
    email = "mlieberman85@gmail.com";
    github = "mlieberman85";
    githubId = 622577;
    name = "Michael Lieberman";
  };
  mlvzk = {
    name = "mlvzk";
    email = "mlvzk@users.noreply.github.com";
    github = "mlvzk";
    githubId = 44906333;
  };
  mmahut = {
    email = "marek.mahut@gmail.com";
    github = "mmahut";
    githubId = 104795;
    name = "Marek Mahut";
  };
  mmai = {
    email = "henri.bourcereau@gmail.com";
    github = "mmai";
    githubId = 117842;
    name = "Henri Bourcereau";
  };
  mmesch = {
    email = "mmesch@noreply.github.com";
    github = "MMesch";
    githubId = 2597803;
    name = "Matthias Meschede";
  };
  mmilata = {
    email = "martin@martinmilata.cz";
    github = "mmilata";
    githubId = 85857;
    name = "Martin Milata";
  };
  mmlb = {
    email = "manny@peekaboo.mmlb.icu";
    github = "mmlb";
    githubId = 708570;
    name = "Manuel Mendez";
  };
  mnacamura = {
    email = "m.nacamura@gmail.com";
    github = "mnacamura";
    githubId = 45770;
    name = "Mitsuhiro Nakamura";
  };
  moaxcp = {
    email = "moaxcp@gmail.com";
    github = "moaxcp";
    githubId = 7831184;
    name = "John Mercier";
  };
  modulistic = {
    email = "modulistic@gmail.com";
    github = "modulistic";
    githubId = 1902456;
    name = "Pablo Costa";
  };
  mog = {
    email = "mog-lists@rldn.net";
    github = "mogorman";
    githubId = 64710;
    name = "Matthew O'Gorman";
  };
  Mogria = {
    email = "m0gr14@gmail.com";
    github = "mogria";
    githubId = 754512;
    name = "Mogria";
  };
  mohe2015 = {
    name = "Moritz Hedtke";
    email = "Moritz.Hedtke@t-online.de";
    matrix = "@moritz.hedtke:matrix.org";
    github = "mohe2015";
    githubId = 13287984;
    keys = [{
      fingerprint = "1248 D3E1 1D11 4A85 75C9  8934 6794 D45A 488C 2EDE";
    }];
  };
  monaaraj = {
    name = "Mon Aaraj";
    email = "owo69uwu69@gmail.com";
    matrix = "@mon:tchncs.de";
    github = "MonAaraj";
    githubId = 46468162;
  };
  monsieurp = {
    email = "monsieurp@gentoo.org";
    github = "monsieurp";
    githubId = 350116;
    name = "Patrice Clement";
  };
  montag451 = {
    email = "montag451@laposte.net";
    github = "montag451";
    githubId = 249317;
    name = "montag451";
  };
  montchr = {
    name = "Chris Montgomery";
    email = "chris@cdom.io";
    github = "montchr";
    githubId = 1757914;
    keys = [{
      fingerprint = "6460 4147 C434 F65E C306  A21F 135E EDD0 F719 34F3";
    }];
  };
  moosingin3space = {
    email = "moosingin3space@gmail.com";
    github = "moosingin3space";
    githubId = 830082;
    name = "Nathan Moos";
  };
  moredread = {
    email = "code@apb.name";
    github = "Moredread";
    githubId = 100848;
    name = "André-Patrick Bubel";
    keys = [{
      fingerprint = "4412 38AD CAD3 228D 876C  5455 118C E7C4 24B4 5728";
    }];
  };
  moretea = {
    email = "maarten@moretea.nl";
    github = "moretea";
    githubId = 99988;
    name = "Maarten Hoogendoorn";
  };
  MoritzBoehme = {
    email = "mail@moritzboeh.me";
    github = "MoritzBoehme";
    githubId = 42215704;
    name = "Moritz Böhme";
  };
  MostAwesomeDude = {
    email = "cds@corbinsimpson.com";
    github = "MostAwesomeDude";
    githubId = 118035;
    name = "Corbin Simpson";
  };
  mothsart = {
    email = "jerem.ferry@gmail.com";
    github = "mothsART";
    githubId = 10601196;
    name = "Jérémie Ferry";
  };
  mounium = {
    email = "muoniurn@gmail.com";
    github = "Mounium";
    githubId = 20026143;
    name = "Katona László";
  };
  MP2E = {
    email = "MP2E@archlinux.us";
    github = "MP2E";
    githubId = 167708;
    name = "Cray Elliott";
  };
  mpcsh = {
    email = "m@mpc.sh";
    github = "mpcsh";
    githubId = 2894019;
    name = "Mark Cohen";
  };
  mpickering = {
    email = "matthewtpickering@gmail.com";
    github = "mpickering";
    githubId = 1216657;
    name = "Matthew Pickering";
  };
  mpoquet = {
    email = "millian.poquet@gmail.com";
    github = "mpoquet";
    githubId = 3502831;
    name = "Millian Poquet";
  };
  mpscholten = {
    email = "marc@digitallyinduced.com";
    github = "mpscholten";
    githubId = 2072185;
    name = "Marc Scholten";
  };
  mtrsk = {
    email = "marcos.schonfinkel@protonmail.com";
    github = "mtrsk";
    githubId = 16356569;
    name = "Marcos Benevides";
  };
  mredaelli = {
    email = "massimo@typish.io";
    github = "mredaelli";
    githubId = 3073833;
    name = "Massimo Redaelli";
  };
  mrkkrp = {
    email = "markkarpov92@gmail.com";
    github = "mrkkrp";
    githubId = 8165792;
    name = "Mark Karpov";
  };
  mrmebelman = {
    email = "burzakovskij@protonmail.com";
    github = "MrMebelMan";
    githubId = 15896005;
    name = "Vladyslav Burzakovskyy";
  };
  mrtarantoga = {
    email = "goetz-dev@web.de";
    name = "Götz Grimmer";
    github = "MrTarantoga";
    githubId = 53876219;
  };
  mrVanDalo = {
    email = "contact@ingolf-wagner.de";
    github = "mrVanDalo";
    githubId = 839693;
    name = "Ingolf Wanger";
  };
  mschristiansen = {
    email = "mikkel@rheosystems.com";
    github = "mschristiansen";
    githubId = 437005;
    name = "Mikkel Christiansen";
  };
  mschuwalow = {
    github = "mschuwalow";
    githubId = 16665913;
    name = "Maxim Schuwalow";
    email = "maxim.schuwalow@gmail.com";
  };
  msfjarvis = {
    github = "msfjarvis";
    githubId = 13348378;
    name = "Harsh Shandilya";
    email = "nixos@msfjarvis.dev";
    keys = [{
      fingerprint = "8F87 050B 0F9C B841 1515  7399 B784 3F82 3355 E9B9";
    }];
  };
  msiedlarek = {
    email = "mikolaj@siedlarek.pl";
    github = "msiedlarek";
    githubId = 133448;
    name = "Mikołaj Siedlarek";
  };
  msm = {
    email = "msm@tailcall.net";
    github = "msm-code";
    githubId = 7026881;
    name = "Jarosław Jedynak";
  };
  mstarzyk = {
    email = "mstarzyk@gmail.com";
    github = "mstarzyk";
    githubId = 111304;
    name = "Maciek Starzyk";
  };
  msteen = {
    email = "emailmatthijs@gmail.com";
    github = "msteen";
    githubId = 788953;
    name = "Matthijs Steen";
  };
  mstrangfeld = {
    email = "marvin@strangfeld.io";
    github = "mstrangfeld";
    githubId = 36842980;
    name = "Marvin Strangfeld";
  };
  mt-caret = {
    email = "mtakeda.enigsol@gmail.com";
    github = "mt-caret";
    githubId = 4996739;
    name = "Masayuki Takeda";
  };
  mtesseract = {
    email = "moritz@stackrox.com";
    github = "mtesseract";
    githubId = 11706080;
    name = "Moritz Clasmeier";
  };
  mtoohey = {
    name = "Matthew Toohey";
    email = "contact@mtoohey.com";
    github = "mtoohey31";
    githubId = 36740602;
  };
  MtP = {
    email = "marko.nixos@poikonen.de";
    github = "MtP76";
    githubId = 2176611;
    name = "Marko Poikonen";
  };
  mtreca = {
    email = "maxime.treca@gmail.com";
    github = "mtreca";
    githubId = 16440823;
    name = "Maxime Tréca";
  };
  mtreskin = {
    email = "zerthurd@gmail.com";
    github = "Zert";
    githubId = 39034;
    name = "Max Treskin";
  };
  mudri = {
    email = "lamudri@gmail.com";
    github = "laMudri";
    githubId = 5139265;
    name = "James Wood";
  };
  mudrii = {
    email = "mudreac@gmail.com";
    github = "mudrii";
    githubId = 220262;
    name = "Ion Mudreac";
  };
  multun = {
    email = "victor.collod@epita.fr";
    github = "multun";
    githubId = 5047140;
    name = "Victor Collod";
  };
  munksgaard = {
    name = "Philip Munksgaard";
    email = "philip@munksgaard.me";
    github = "munksgaard";
    githubId = 230613;
    matrix = "@philip:matrix.munksgaard.me";
    keys = [{
      fingerprint = "5658 4D09 71AF E45F CC29 6BD7 4CE6 2A90 EFC0 B9B2";
    }];
  };
  muscaln = {
    email = "muscaln@protonmail.com";
    github = "muscaln";
    githubId = 96225281;
    name = "Mustafa Çalışkan";
  };
  mupdt = {
    email = "nix@pdtpartners.com";
    github = "mupdt";
    githubId = 25388474;
    name = "Matej Urbas";
  };
  mvisonneau = {
    name = "Maxime VISONNEAU";
    email = "maxime@visonneau.fr";
    matrix = "@maxime:visonneau.fr";
    github = "mvisonneau";
    githubId = 1761583;
    keys = [{
      fingerprint = "EC63 0CEA E8BC 5EE5 5C58  F2E3 150D 6F0A E919 8D24";
    }];
  };
  mvnetbiz = {
    email = "mvnetbiz@gmail.com";
    matrix = "@mvtva:matrix.org";
    github = "mvnetbiz";
    githubId = 6455574;
    name = "Matt Votava";
  };
  mvs = {
    email = "mvs@nya.yt";
    github = "illdefined";
    githubId = 772914;
    name = "Mikael Voss";
  };
  mwolfe = {
    email = "corp@m0rg.dev";
    github = "m0rg-dev";
    githubId = 38578268;
    name = "Morgan Wolfe";
  };
  maxwilson = {
    email = "nixpkgs@maxwilson.dev";
    github = "mwilsoncoding";
    githubId = 43796009;
    name = "Max Wilson";
  };
  myaats = {
    email = "mats@mats.sh";
    github = "Myaats";
    githubId = 6295090;
    name = "Mats";
  };
  myrl = {
    email = "myrl.0xf@gmail.com";
    github = "Myrl";
    githubId = 9636071;
    name = "Myrl Hex";
  };
  n0emis = {
    email = "nixpkgs@n0emis.network";
    github = "n0emis";
    githubId = 22817873;
    name = "Ember Keske";
  };
  nadrieril = {
    email = "nadrieril@gmail.com";
    github = "Nadrieril";
    githubId = 6783654;
    name = "Nadrieril Feneanar";
  };
  nagy = {
    email = "danielnagy@posteo.de";
    github = "nagy";
    githubId = 692274;
    name = "Daniel Nagy";
    keys = [{
      fingerprint = "F6AE 2C60 9196 A1BC ECD8  7108 1B8E 8DCB 576F B671";
    }];
  };
  nalbyuites = {
    email = "ashijit007@gmail.com";
    github = "nalbyuites";
    githubId = 1009523;
    name = "Ashijit Pramanik";
  };
  namore = {
    email = "namor@hemio.de";
    github = "namore";
    githubId = 1222539;
    name = "Roman Naumann";
  };
  naphta = {
    email = "naphta@noreply.github.com";
    github = "naphta";
    githubId = 6709831;
    name = "Jake Hill";
  };
  nasirhm = {
    email = "nasirhussainm14@gmail.com";
    github = "nasirhm";
    githubId = 35005234;
    name = "Nasir Hussain";
    keys = [{
      fingerprint = "7A10 AB8E 0BEC 566B 090C  9BE3 D812 6E55 9CE7 C35D";
    }];
  };
  nat-418 = {
    email = "93013864+nat-418@users.noreply.github.com";
    github = "nat-418";
    githubId = 93013864;
    name = "nat-418";
  };
  nathanruiz = {
    email = "nathanruiz@protonmail.com";
    github = "nathanruiz";
    githubId = 18604892;
    name = "Nathan Ruiz";
  };
  nathan-gs = {
    email = "nathan@nathan.gs";
    github = "nathan-gs";
    githubId = 330943;
    name = "Nathan Bijnens";
  };
  nathyong = {
    email = "nathyong@noreply.github.com";
    github = "nathyong";
    githubId = 818502;
    name = "Nathan Yong";
  };
  natsukium = {
    email = "nixpkgs@natsukium.com";
    github = "natsukium";
    githubId = 25083790;
    name = "Tomoya Otabi";
    keys = [{
      fingerprint = "3D14 6004 004C F882 D519  6CD4 9EA4 5A31 DB99 4C53";
    }];
  };
  natto1784 = {
    email = "natto@weirdnatto.in";
    github = "natto1784";
    githubId = 56316606;
    name = "Amneesh Singh";
  };
  nazarewk = {
    name = "Krzysztof Nazarewski";
    email = "3494992+nazarewk@users.noreply.github.com";
    matrix = "@nazarewk:matrix.org";
    github = "nazarewk";
    githubId = 3494992;
    keys = [{
      fingerprint = "4BFF 0614 03A2 47F0 AA0B 4BC4 916D 8B67 2418 92AE";
    }];
  };
  nbr = {
    email = "nbr@users.noreply.github.com";
    github = "nbr";
    githubId = 3819225;
    name = "Nick Braga";
  };
  nbren12 = {
    email = "nbren12@gmail.com";
    github = "nbren12";
    githubId = 1386642;
    name = "Noah Brenowitz";
  };
  ncfavier = {
    email = "n@monade.li";
    matrix = "@ncfavier:matrix.org";
    github = "ncfavier";
    githubId = 4323933;
    name = "Naïm Favier";
    keys = [{
      fingerprint = "F3EB 4BBB 4E71 99BC 299C  D4E9 95AF CE82 1190 8325";
    }];
  };
  nckx = {
    email = "github@tobias.gr";
    github = "nckx";
    githubId = 364510;
    name = "Tobias Geerinckx-Rice";
  };
  ndl = {
    email = "ndl@endl.ch";
    github = "ndl";
    githubId = 137805;
    name = "Alexander Tsvyashchenko";
  };
  Necior = {
    email = "adrian@sadlocha.eu";
    github = "Necior";
    githubId = 2404518;
    matrix = "@n3t:matrix.org";
    name = "Adrian Sadłocha";
  };
  neeasade = {
    email = "nathanisom27@gmail.com";
    github = "neeasade";
    githubId = 3747396;
    name = "Nathan Isom";
  };
  necrophcodr = {
    email = "nc@scalehost.eu";
    github = "necrophcodr";
    githubId = 575887;
    name = "Steffen Rytter Postas";
  };
  neilmayhew = {
    email = "nix@neil.mayhew.name";
    github = "neilmayhew";
    githubId = 166791;
    name = "Neil Mayhew";
  };
  nek0 = {
    email = "nek0@nek0.eu";
    github = "nek0";
    githubId = 1859691;
    name = "Amedeo Molnár";
  };
  nelsonjeppesen = {
    email = "nix@jeppesen.io";
    github = "NelsonJeppesen";
    githubId = 50854675;
    name = "Nelson Jeppesen";
  };
  neonfuz = {
    email = "neonfuz@gmail.com";
    github = "neonfuz";
    githubId = 2590830;
    name = "Sage Raflik";
  };
  neosimsim = {
    email = "me@abn.sh";
    github = "neosimsim";
    githubId = 1771772;
    name = "Alexander Ben Nasrallah";
  };
  nequissimus = {
    email = "tim@nequissimus.com";
    github = "NeQuissimus";
    githubId = 628342;
    name = "Tim Steinbach";
  };
  nerdypepper = {
    email = "nerdy@peppe.rs";
    github = "nerdypepper";
    githubId = 23743547;
    name = "Akshay Oppiliappan";
  };
  ners = {
    name = "ners";
    email = "ners@gmx.ch";
    matrix = "@ners:ners.ch";
    github = "ners";
    githubId = 50560955;
  };
  nessdoor = {
    name = "Tomas Antonio Lopez";
    email = "entropy.overseer@protonmail.com";
    github = "nessdoor";
    githubId = 25993494;
  };
  net-mist = {
    email = "archimist.linux@gmail.com";
    github = "Net-Mist";
    githubId = 13920346;
    name = "Sébastien Iooss";
  };
  netali = {
    name = "Jennifer Graul";
    email = "me@netali.de";
    github = "NetaliDev";
    githubId = 15304894;
    keys = [{
      fingerprint = "F729 2594 6F58 0B05 8FB3  F271 9C55 E636 426B 40A9";
    }];
  };
  netcrns = {
    email = "jason.wing@gmx.de";
    github = "netcrns";
    githubId = 34162313;
    name = "Jason Wing";
  };
  netixx = {
    email = "dev.espinetfrancois@gmail.com";
    github = "netixx";
    githubId = 1488603;
    name = "François Espinet";
  };
  neverbehave = {
    email = "i@never.pet";
    github = "NeverBehave";
    githubId = 17120571;
    name = "Xinhao Luo";
  };
  newam = {
    email = "alex@thinglab.org";
    github = "newAM";
    githubId = 7845120;
    name = "Alex Martens";
  };
  nialov = {
    email = "nikolasovaskainen@gmail.com";
    github = "nialov";
    githubId = 47318483;
    name = "Nikolas Ovaskainen";
  };
  nikitavoloboev = {
    email = "nikita.voloboev@gmail.com";
    github = "nikitavoloboev";
    githubId = 6391776;
    name = "Nikita Voloboev";
  };
  ngiger = {
    email = "niklaus.giger@member.fsf.org";
    github = "ngiger";
    githubId = 265800;
    name = "Niklaus Giger";
  };
  nh2 = {
    email = "mail@nh2.me";
    matrix = "@nh2:matrix.org";
    github = "nh2";
    githubId = 399535;
    name = "Niklas Hambüchen";
  };
  nhooyr = {
    email = "anmol@aubble.com";
    github = "nhooyr";
    githubId = 10180857;
    name = "Anmol Sethi";
  };
  nicbk = {
    email = "nicolas@nicbk.com";
    github = "nicbk";
    githubId = 77309427;
    name = "Nicolás Kennedy";
    keys = [{
      fingerprint = "7BC1 77D9 C222 B1DC FB2F  0484 C061 089E FEBF 7A35";
    }];
  };
  nichtsfrei = {
    email = "philipp.eder@posteo.net";
    github = "nichtsfrei";
    githubId = 1665818;
    name = "Philipp Eder";
  };
  nickcao = {
    name = "Nick Cao";
    email = "nickcao@nichi.co";
    github = "NickCao";
    githubId = 15247171;
  };
  nickhu = {
    email = "me@nickhu.co.uk";
    github = "NickHu";
    githubId = 450276;
    name = "Nick Hu";
  };
  nicknovitski = {
    email = "nixpkgs@nicknovitski.com";
    github = "nicknovitski";
    githubId = 151337;
    name = "Nick Novitski";
  };
  nico202 = {
    email = "anothersms@gmail.com";
    github = "nico202";
    githubId = 8214542;
    name = "Nicolò Balzarotti";
  };
  nidabdella = {
    name = "Mohamed Nidabdella";
    email = "nidabdella.mohamed@gmail.com";
    github = "nidabdella";
    githubId = 8083813;
  };
  NieDzejkob = {
    email = "kuba@kadziolka.net";
    github = "meithecatte";
    githubId = 23580910;
    name = "Jakub Kądziołka";
    keys = [{
      fingerprint = "E576 BFB2 CF6E B13D F571  33B9 E315 A758 4613 1564";
    }];
  };
  NikolaMandic = {
    email = "nikola@mandic.email";
    github = "NikolaMandic";
    githubId = 4368690;
    name = "Ratko Mladic";
  };
  nilp0inter = {
    email = "robertomartinezp@gmail.com";
    github = "nilp0inter";
    githubId = 1224006;
    name = "Roberto Abdelkader Martínez Pérez";
  };
  nilsirl = {
    email = "nils@nilsand.re";
    github = "NilsIrl";
    githubId = 26231126;
    name = "Nils ANDRÉ-CHANG";
  };
  nils-degroot = {
    email = "nils@peeko.nl";
    github = "nils-degroot";
    githubId = 53556985;
    name = "Nils de Groot";
  };
  ninjatrappeur = {
    email = "felix@alternativebit.fr";
    matrix = "@ninjatrappeur:matrix.org";
    github = "NinjaTrappeur";
    githubId = 1219785;
    name = "Félix Baylac-Jacqué";
  };
  ninjin = {
    email = "pontus@stenetorp.se";
    github = "ninjin";
    githubId = 354934;
    name = "Pontus Stenetorp";
    keys = [{
      fingerprint = "0966 2F9F 3FDA C22B C22E  4CE1 D430 2875 00E6 483C";
    }];
  };
  nioncode = {
    email = "nioncode+github@gmail.com";
    github = "nioncode";
    githubId = 3159451;
    name = "Nicolas Schneider";
  };
  nkje = {
    name = "Niels Kristian Lyshøj Jensen";
    email = "n@nk.je";
    github = "NKJe";
    githubId = 1102306;
    keys = [{
      fingerprint = "B956 C6A4 22AF 86A0 8F77  A8CA DE3B ADFE CD31 A89D";
    }];
  };
  nitsky = {
    name = "nitsky";
    email = "492793+nitsky@users.noreply.github.com";
    github = "nitsky";
    githubId = 492793;
  };
  nkpvk = {
    email = "niko.pavlinek@gmail.com";
    github = "npavlinek";
    githubId = 16385648;
    name = "Niko Pavlinek";
  };
  nixbitcoin = {
    email = "nixbitcoin@i2pmail.org";
    github = "nixbitcoin";
    githubId = 45737139;
    name = "nixbitcoindev";
    keys = [{
      fingerprint = "577A 3452 7F3E 2A85 E80F  E164 DD11 F9AD 5308 B3BA";
    }];
  };
  nixinator = {
    email = "33lockdown33@protonmail.com";
    matrix = "@nixinator:nixos.dev";
    github = "nixinator";
    githubId = 66913205;
    name = "Rick Sanchez";
  };
  nixy = {
    email = "nixy@nixy.moe";
    github = "nixy";
    githubId = 7588406;
    name = "Andrew R. M.";
  };
  nkalupahana = {
    email = "hello@nisa.la";
    github = "nkalupahana";
    githubId = 7347290;
    name = "Nisala Kalupahana";
  };
  nloomans = {
    email = "noah@nixos.noahloomans.com";
    github = "nloomans";
    githubId = 7829481;
    name = "Noah Loomans";
  };
  nmattia = {
    email = "nicolas@nmattia.com";
    github = "nmattia";
    githubId = 6930756;
    name = "Nicolas Mattia";
  };
  nobbz = {
    name = "Norbert Melzer";
    email = "timmelzer+nixpkgs@gmail.com";
    github = "NobbZ";
    githubId = 58951;
  };
  nocoolnametom = {
    email = "nocoolnametom@gmail.com";
    github = "nocoolnametom";
    githubId = 810877;
    name = "Tom Doggett";
  };
  noisersup = {
    email = "patryk@kwiatek.xyz";
    github = "noisersup";
    githubId = 42322511;
    name = "Patryk Kwiatek";
  };
  nomeata = {
    email = "mail@joachim-breitner.de";
    github = "nomeata";
    githubId = 148037;
    name = "Joachim Breitner";
  };
  nomisiv = {
    email = "simon@nomisiv.com";
    github = "NomisIV";
    githubId = 47303199;
    name = "Simon Gutgesell";
  };
  noneucat = {
    email = "andy@lolc.at";
    matrix = "@noneucat:lolc.at";
    github = "noneucat";
    githubId = 40049608;
    name = "Andy Chun";
  };
  nook = {
    name = "Tom Nook";
    email = "0xnook@protonmail.com";
    github = "0xnook";
    githubId = 88323754;
  };
  noreferences = {
    email = "norkus@norkus.net";
    github = "jozuas";
    githubId = 13085275;
    name = "Juozas Norkus";
  };
  norfair = {
    email = "syd@cs-syd.eu";
    github = "NorfairKing";
    githubId = 3521180;
    name = "Tom Sydney Kerckhove";
  };
  notthemessiah = {
    email = "brian.cohen.88@gmail.com";
    github = "NOTtheMessiah";
    githubId = 2946283;
    name = "Brian Cohen";
  };
  novoxd = {
    email = "radnovox@gmail.com";
    github = "novoxd";
    githubId = 6052922;
    name = "Kirill Struokov";
  };
  np = {
    email = "np.nix@nicolaspouillard.fr";
    github = "np";
    githubId = 5548;
    name = "Nicolas Pouillard";
  };
  nphilou = {
    email = "nphilou@gmail.com";
    github = "nphilou";
    githubId = 9939720;
    name = "Philippe Nguyen";
  };
  nrdxp = {
    email = "tim.deh@pm.me";
    matrix = "@timdeh:matrix.org";
    github = "nrdxp";
    githubId = 34083928;
    name = "Tim DeHerrera";
  };
  nshalman = {
    email = "nahamu@gmail.com";
    github = "nshalman";
    githubId = 20391;
    name = "Nahum Shalman";
  };
  nsnelson = {
    email = "noah.snelson@protonmail.com";
    github = "peeley";
    githubId = 30942198;
    name = "Noah Snelson";
  };
  nthorne = {
    email = "notrupertthorne@gmail.com";
    github = "nthorne";
    githubId = 1839979;
    name = "Niklas Thörne";
  };
  nukaduka = {
    email = "ksgokte@gmail.com";
    github = "NukaDuka";
    githubId = 22592293;
    name = "Kartik Gokte";
  };
  nullx76 = {
    email = "nix@xirion.net";
    github = "NULLx76";
    githubId = 1809198;
    name = "Victor Roest";
  };
  nullishamy = {
    email = "amy.codes@null.net";
    name = "nullishamy";
    github = "nullishamy";
    githubId = 99221043;
  };
  numinit = {
    email = "me@numin.it";
    github = "numinit";
    githubId = 369111;
    name = "Morgan Jones";
  };
  numkem = {
    name = "Sebastien Bariteau";
    email = "numkem@numkem.org";
    matrix = "@numkem:matrix.org";
    github = "numkem";
    githubId = 332423;
  };
  nviets = {
    email = "nathan.g.viets@gmail.com";
    github = "nviets";
    githubId = 16027994;
    name = "Nathan Viets";
  };
  nyanloutre = {
    email = "paul@nyanlout.re";
    github = "nyanloutre";
    githubId = 7677321;
    name = "Paul Trehiou";
  };
  nyanotech = {
    name = "nyanotech";
    email = "nyanotechnology@gmail.com";
    github = "nyanotech";
    githubId = 33802077;
  };
  nyarly = {
    email = "nyarly@gmail.com";
    github = "nyarly";
    githubId = 127548;
    name = "Judson Lester";
  };
  nzbr = {
    email = "nixos@nzbr.de";
    github = "nzbr";
    githubId = 7851175;
    name = "nzbr";
    matrix = "@nzbr:nzbr.de";
    keys = [{
      fingerprint = "BF3A 3EE6 3144 2C5F C9FB  39A7 6C78 B50B 97A4 2F8A";
    }];
  };
  nzhang-zh = {
    email = "n.zhang.hp.au@gmail.com";
    github = "nzhang-zh";
    githubId = 30825096;
    name = "Ning Zhang";
  };
  obadz = {
    email = "obadz-nixos@obadz.com";
    github = "obadz";
    githubId = 3359345;
    name = "obadz";
  };
  oberblastmeister = {
    email = "littlebubu.shu@gmail.com";
    github = "oberblastmeister";
    githubId = 61095988;
    name = "Brian Shu";
  };
  obsidian-systems-maintenance = {
    name = "Obsidian Systems Maintenance";
    email = "maintainer@obsidian.systems";
    github = "obsidian-systems-maintenance";
    githubId = 80847921;
  };
  obfusk = {
    email = "flx@obfusk.net";
    matrix = "@obfusk:matrix.org";
    github = "obfusk";
    githubId = 1260687;
    name = "FC Stegerman";
    keys = [{
      fingerprint = "D5E4 A51D F8D2 55B9 FAC6  A9BB 2F96 07F0 9B36 0F2D";
    }];
  };
  ocfox = {
    email = "i@ocfox.me";
    github = "ocfox";
    githubId = 47410251;
    name = "ocfox";
    keys = [{
      fingerprint = "939E F8A5 CED8 7F50 5BB5  B2D0 24BC 2738 5F70 234F";
    }];
  };
  odi = {
    email = "oliver.dunkl@gmail.com";
    github = "odi";
    githubId = 158758;
    name = "Oliver Dunkl";
  };
  ofek = {
    email = "oss@ofek.dev";
    github = "ofek";
    githubId = 9677399;
    name = "Ofek Lev";
  };
  offline = {
    email = "jaka@x-truder.net";
    github = "offlinehacker";
    githubId = 585547;
    name = "Jaka Hudoklin";
  };
  oida = {
    email = "oida@posteo.de";
    github = "oida";
    githubId = 7249506;
    name = "oida";
  };
  olcai = {
    email = "dev@timan.info";
    github = "olcai";
    githubId = 20923;
    name = "Erik Timan";
  };
  olebedev = {
    email = "ole6edev@gmail.com";
    github = "olebedev";
    githubId = 848535;
    name = "Oleg Lebedev";
  };
  olejorgenb = {
    email = "olejorgenb@yahoo.no";
    github = "olejorgenb";
    githubId = 72201;
    name = "Ole Jørgen Brønner";
  };
  ollieB = {
    email = "1237862+oliverbunting@users.noreply.github.com";
    github = "oliverbunting";
    githubId = 1237862;
    name = "Ollie Bunting";
  };
  oluceps = {
    email = "nixos@oluceps.uk";
    github = "oluceps";
    githubId = 35628088;
    name = "oluceps";
  };
  olynch = {
    email = "owen@olynch.me";
    github = "olynch";
    githubId = 4728903;
    name = "Owen Lynch";
  };
  omasanori = {
    email = "167209+omasanori@users.noreply.github.com";
    github = "omasanori";
    githubId = 167209;
    name = "Masanori Ogino";
  };
  omgbebebe = {
    email = "omgbebebe@gmail.com";
    github = "omgbebebe";
    githubId = 588167;
    name = "Sergey Bubnov";
  };
  omnipotententity = {
    email = "omnipotententity@gmail.com";
    github = "OmnipotentEntity";
    githubId = 1538622;
    name = "Michael Reilly";
  };
  onixie = {
    email = "onixie@gmail.com";
    github = "onixie";
    githubId = 817073;
    name = "Yc. Shen";
  };
  onsails = {
    email = "andrey@onsails.com";
    github = "onsails";
    githubId = 107261;
    name = "Andrey Kuznetsov";
  };
  onny = {
    email = "onny@project-insanity.org";
    github = "onny";
    githubId = 757752;
    name = "Jonas Heinrich";
  };
  onthestairs = {
    email = "austinplatt@gmail.com";
    github = "onthestairs";
    githubId = 915970;
    name = "Austin Platt";
  };
  ony = {
    name = "Mykola Orliuk";
    email = "virkony@gmail.com";
    github = "ony";
    githubId = 11265;
  };
  OPNA2608 = {
    email = "christoph.neidahl@gmail.com";
    github = "OPNA2608";
    githubId = 23431373;
    name = "Christoph Neidahl";
  };
  opeik = {
    email = "sandro@stikic.com";
    github = "opeik";
    githubId = 11566773;
    name = "Sandro Stikić";
  };
  orbekk = {
    email = "kjetil.orbekk@gmail.com";
    github = "orbekk";
    githubId = 19862;
    name = "KJ Ørbekk";
  };
  orbitz = {
    email = "mmatalka@gmail.com";
    github = "orbitz";
    githubId = 75299;
    name = "Malcolm Matalka";
  };
  orivej = {
    email = "orivej@gmx.fr";
    github = "orivej";
    githubId = 101514;
    name = "Orivej Desh";
  };
  ornxka = {
    email = "ornxka@littledevil.sh";
    github = "ornxka";
    githubId = 52086525;
    name = "ornxka";
  };
  oro = {
    email = "marco@orovecchia.at";
    github = "Oro";
    githubId = 357005;
    name = "Marco Orovecchia";
  };
  osener = {
    email = "ozan@ozansener.com";
    github = "osener";
    githubId = 111265;
    name = "Ozan Sener";
  };
  otavio = {
    email = "otavio.salvador@ossystems.com.br";
    github = "otavio";
    githubId = 25278;
    name = "Otavio Salvador";
  };
  otini = {
    name = "Olivier Nicole";
    email = "olivier@chnik.fr";
    github = "OlivierNicole";
    githubId = 14031333;
  };
  otwieracz = {
    email = "slawek@otwiera.cz";
    github = "otwieracz";
    githubId = 108072;
    name = "Slawomir Gonet";
  };
  oxalica = {
    email = "oxalicc@pm.me";
    github = "oxalica";
    githubId = 14816024;
    name = "oxalica";
    keys = [{
      fingerprint = "F90F FD6D 585C 2BA1 F13D  E8A9 7571 654C F88E 31C2";
    }];
  };
  oxapentane = {
    email = "blame@oxapentane.com";
    github = "oxapentane";
    githubId = 1297357;
    name = "Grigory Shipunov";
    keys = [{
      fingerprint = "DD09 98E6 CDF2 9453 7FC6  04F9 91FA 5E5B F9AA 901C";
    }];
  };
  oxij = {
    email = "oxij@oxij.org";
    github = "oxij";
    githubId = 391919;
    name = "Jan Malakhovski";
    keys = [{
      fingerprint = "514B B966 B46E 3565 0508  86E8 0E6C A66E 5C55 7AA8";
    }];
  };
  oxzi = {
    email = "post@0x21.biz";
    github = "oxzi";
    githubId = 8402811;
    name = "Alvar Penning";
    keys = [{
      fingerprint = "EB14 4E67 E57D 27E2 B5A4  CD8C F32A 4563 7FA2 5E31";
    }];
  };
  oyren = {
    email = "m.scheuren@oyra.eu";
    github = "oyren";
    githubId = 15930073;
    name = "Moritz Scheuren";
  };
  ovlach = {
    email = "ondrej@vlach.xyz";
    name = "Ondrej Vlach";
    github = "ovlach";
    githubId = 4405107;
  };
  ozkutuk = {
    email = "ozkutuk@protonmail.com";
    github = "ozkutuk";
    githubId = 5948762;
    name = "Berk Özkütük";
  };
  pablovsky = {
    email = "dealberapablo07@gmail.com";
    github = "Pablo1107";
    githubId = 17091659;
    name = "Pablo Andres Dealbera";
  };
  pacien = {
    email = "b4gx3q.nixpkgs@pacien.net";
    github = "pacien";
    githubId = 1449319;
    name = "Pacien Tran-Girard";
  };
  pacman99 = {
    email = "pachum99@gmail.com";
    matrix = "@pachumicchu:myrdd.info";
    github = "Pacman99";
    githubId = 16345849;
    name = "Parthiv Seetharaman";
  };
  paddygord = {
    email = "pgpatrickgordon@gmail.com";
    github = "paddygord";
    githubId = 10776658;
    name = "Patrick Gordon";
  };
  paholg = {
    email = "paho@paholg.com";
    github = "paholg";
    githubId = 4908217;
    name = "Paho Lurie-Gregg";
  };
  pakhfn = {
    email = "pakhfn@gmail.com";
    github = "pakhfn";
    githubId = 11016164;
    name = "Fedor Pakhomov";
  };
  paluh = {
    email = "paluho@gmail.com";
    github = "paluh";
    githubId = 190249;
    name = "Tomasz Rybarczyk";
  };
  pamplemousse = {
    email = "xav.maso@gmail.com";
    matrix = "@pamplemouss_:matrix.org";
    github = "Pamplemousse";
    githubId = 2647236;
    name = "Xavier Maso";
  };
  panaeon = {
    email = "vitalii.voloshyn@gmail.com";
    github = "PanAeon";
    githubId = 686076;
    name = "Vitalii Voloshyn";
  };
  pandaman = {
    email = "kointosudesuyo@infoseek.jp";
    github = "pandaman64";
    githubId = 1788628;
    name = "pandaman";
  };
  panicgh = {
    email = "nbenes.gh@xandea.de";
    github = "panicgh";
    githubId = 79252025;
    name = "Nicolas Benes";
  };
  paperdigits = {
    email = "mica@silentumbrella.com";
    github = "paperdigits";
    githubId = 71795;
    name = "Mica Semrick";
  };
  annaaurora = {
    email = "anna@annaaurora.eu";
    matrix = "@papojari:artemislena.eu";
    github = "auroraanna";
    githubId = 81317317;
    name = "Anna Aurora";
  };
  paraseba = {
    email = "paraseba@gmail.com";
    github = "paraseba";
    githubId = 20792;
    name = "Sebastian Galkin";
  };
  parasrah = {
    email = "nixos@parasrah.com";
    github = "Parasrah";
    githubId = 14935550;
    name = "Brad Pfannmuller";
  };
  parras = {
    email = "c@philipp-arras.de";
    github = "phiadaarr";
    githubId = 33826198;
    name = "Philipp Arras";
  };
  pashashocky = {
    email = "pashashocky@gmail.com";
    github = "pashashocky";
    githubId = 673857;
    name = "Pash Shocky";
  };
  pashev = {
    email = "pashev.igor@gmail.com";
    github = "ip1981";
    githubId = 131844;
    name = "Igor Pashev";
  };
  pasqui23 = {
    email = "p3dimaria@hotmail.it";
    github = "pasqui23";
    githubId = 6931743;
    name = "pasqui23";
  };
  patricksjackson = {
    email = "patrick@jackson.dev";
    github = "patricksjackson";
    githubId = 160646;
    name = "Patrick Jackson";
  };
  patryk27 = {
    email = "pwychowaniec@pm.me";
    github = "Patryk27";
    githubId = 3395477;
    name = "Patryk Wychowaniec";
    keys = [{
      fingerprint = "196A BFEC 6A1D D1EC 7594  F8D1 F625 47D0 75E0 9767";
    }];
  };
  patryk4815 = {
    email = "patryk.sondej@gmail.com";
    github = "patryk4815";
    githubId = 3074260;
    name = "Patryk Sondej";
  };
  patternspandemic = {
    email = "patternspandemic@live.com";
    github = "patternspandemic";
    githubId = 15645854;
    name = "Brad Christensen";
  };
  payas = {
    email = "relekarpayas@gmail.com";
    github = "bhankas";
    githubId = 24254289;
    name = "Payas Relekar";
  };
  pawelpacana = {
    email = "pawel.pacana@gmail.com";
    github = "pawelpacana";
    githubId = 116740;
    name = "Paweł Pacana";
  };
  pb- = {
    email = "pbaecher@gmail.com";
    github = "pb-";
    githubId = 84886;
    name = "Paul Baecher";
  };
  pbar = {
    email = "piercebartine@gmail.com";
    github = "pbar1";
    githubId = 26949935;
    name = "Pierce Bartine";
  };
  pbogdan = {
    email = "ppbogdan@gmail.com";
    github = "pbogdan";
    githubId = 157610;
    name = "Piotr Bogdan";
  };
  pborzenkov = {
    email = "pavel@borzenkov.net";
    github = "pborzenkov";
    githubId = 434254;
    name = "Pavel Borzenkov";
  };
  pblkt = {
    email = "pebblekite@gmail.com";
    github = "pblkt";
    githubId = 6498458;
    name = "pebble kite";
  };
  pbsds = {
    name = "Peder Bergebakken Sundt";
    email = "pbsds@hotmail.com";
    github = "pbsds";
    githubId = 140964;
  };
  pcarrier = {
    email = "pc@rrier.ca";
    github = "pcarrier";
    githubId = 8641;
    name = "Pierre Carrier";
  };
  pedrohlc = {
    email = "root@pedrohlc.com";
    github = "PedroHLC";
    githubId = 1368952;
    name = "Pedro Lara Campos";
  };
  penguwin = {
    email = "penguwin@penguwin.eu";
    github = "penguwin";
    githubId = 13225611;
    name = "Nicolas Martin";
  };
  pennae = {
    name = "pennae";
    email = "github@quasiparticle.net";
    github = "pennae";
    githubId = 82953136;
  };
  p3psi = {
    name = "Elliot Boo";
    email = "p3psi.boo@gmail.com";
    github = "p3psi-boo";
    githubId = 43925055;
  };
  periklis = {
    email = "theopompos@gmail.com";
    github = "periklis";
    githubId = 152312;
    name = "Periklis Tsirakidis";
  };
  petercommand = {
    email = "petercommand@gmail.com";
    github = "petercommand";
    githubId = 1260660;
    name = "petercommand";
  };
  peterhoeg = {
    email = "peter@hoeg.com";
    matrix = "@peter:hoeg.com";
    github = "peterhoeg";
    githubId = 722550;
    name = "Peter Hoeg";
  };
  peterromfeldhk = {
    email = "peter.romfeld.hk@gmail.com";
    github = "peterromfeldhk";
    githubId = 5515707;
    name = "Peter Romfeld";
  };
  petersjt014 = {
    email = "petersjt014@gmail.com";
    github = "petersjt014";
    githubId = 29493551;
    name = "Josh Peters";
  };
  peterwilli = {
    email = "peter@codebuffet.co";
    github = "peterwilli";
    githubId = 1212814;
    name = "Peter Willemsen";
    keys = [{
      fingerprint = "A37F D403 88E2 D026 B9F6  9617 5C9D D4BF B96A 28F0";
    }];
  };
  peti = {
    email = "simons@cryp.to";
    github = "peti";
    githubId = 28323;
    name = "Peter Simons";
  };
  petrosagg = {
    email = "petrosagg@gmail.com";
    github = "petrosagg";
    githubId = 939420;
    name = "Petros Angelatos";
  };
  petterstorvik = {
    email = "petterstorvik@gmail.com";
    github = "storvik";
    githubId = 3438604;
    name = "Petter Storvik";
  };
  p-h = {
    email = "p@hurlimann.org";
    github = "p-h";
    githubId = 645664;
    name = "Philippe Hürlimann";
  };
  phaer = {
    name = "Paul Haerle";
    email = "nix@phaer.org";

    matrix = "@phaer:matrix.org";
    github = "phaer";
    githubId = 101753;
    keys = [{
      fingerprint = "5D69 CF04 B7BC 2BC1 A567  9267 00BC F29B 3208 0700";
    }];
  };
  phdcybersec = {
    name = "Léo Lavaur";
    email = "phdcybersec@pm.me";

    github = "phdcybersec";
    githubId = 82591009;
    keys = [{
      fingerprint = "7756 E88F 3C6A 47A5 C5F0  CDFB AB54 6777 F93E 20BF";
    }];
  };
  phfroidmont = {
    name = "Paul-Henri Froidmont";
    email = "nix.contact-j9dw4d@froidmont.org";

    github = "phfroidmont";
    githubId = 8150907;
    keys = [{
      fingerprint = "3AC6 F170 F011 33CE 393B  CD94 BE94 8AFD 7E78 73BE";
    }];
  };
  philandstuff = {
    email = "philip.g.potter@gmail.com";
    github = "philandstuff";
    githubId = 581269;
    name = "Philip Potter";
  };
  phile314 = {
    email = "nix@314.ch";
    github = "phile314";
    githubId = 1640697;
    name = "Philipp Hausmann";
  };
  Philipp-M = {
    email = "philipp@mildenberger.me";
    github = "Philipp-M";
    githubId = 9267430;
    name = "Philipp Mildenberger";
  };
  Phlogistique = {
    email = "noe.rubinstein@gmail.com";
    github = "Phlogistique";
    githubId = 421510;
    name = "Noé Rubinstein";
  };
  photex = {
    email = "photex@gmail.com";
    github = "photex";
    githubId = 301903;
    name = "Chip Collier";
  };
  phryneas = {
    email = "mail@lenzw.de";
    github = "phryneas";
    githubId = 4282439;
    name = "Lenz Weber";
  };
  phunehehe = {
    email = "phunehehe@gmail.com";
    github = "phunehehe";
    githubId = 627831;
    name = "Hoang Xuan Phu";
  };
  piegames = {
    name = "piegames";
    email = "nix@piegames.de";
    matrix = "@piegames:matrix.org";
    github = "piegamesde";
    githubId = 14054505;
  };
  pierrechevalier83 = {
    email = "pierrechevalier83@gmail.com";
    github = "pierrechevalier83";
    githubId = 5790907;
    name = "Pierre Chevalier";
  };
  pierreis = {
    email = "pierre@pierre.is";
    github = "pierreis";
    githubId = 203973;
    name = "Pierre Matri";
  };
  pierrer = {
    email = "pierrer@pi3r.be";
    github = "PierreR";
    githubId = 93115;
    name = "Pierre Radermecker";
  };
  pierron = {
    email = "nixos@nbp.name";
    github = "nbp";
    githubId = 1179566;
    name = "Nicolas B. Pierron";
  };
  pimeys = {
    email = "julius@nauk.io";
    github = "pimeys";
    githubId = 34967;
    name = "Julius de Bruijn";
  };
  pingiun = {
    email = "nixos@pingiun.com";
    github = "pingiun";
    githubId = 1576660;
    name = "Jelle Besseling";
    keys = [{
      fingerprint = "A3A3 65AE 16ED A7A0 C29C  88F1 9712 452E 8BE3 372E";
    }];
  };
  pinpox = {
    email = "mail@pablo.tools";
    github = "pinpox";
    githubId = 1719781;
    name = "Pablo Ovelleiro Corral";
    keys = [{
      fingerprint = "D03B 218C AE77 1F77 D7F9  20D9 823A 6154 4264 08D3";
    }];
  };
  piperswe = {
    email = "contact@piperswe.me";
    github = "piperswe";
    githubId = 1830959;
    name = "Piper McCorkle";
  };
  pjbarnoy = {
    email = "pjbarnoy@gmail.com";
    github = "pjbarnoy";
    githubId = 119460;
    name = "Perry Barnoy";
  };
  pjjw = {
    email = "peter@shortbus.org";
    github = "pjjw";
    githubId = 638;
    name = "Peter Woodman";
  };
  pjones = {
    email = "pjones@devalot.com";
    github = "pjones";
    githubId = 3737;
    name = "Peter Jones";
  };
  pkharvey = {
    email = "kayharvey@protonmail.com";
    github = "pkharvey";
    githubId = 50750875;
    name = "Paul Harvey";
  };
  pkmx = {
    email = "pkmx.tw@gmail.com";
    github = "PkmX";
    githubId = 610615;
    name = "Chih-Mao Chen";
  };
  plabadens = {
    name = "Pierre Labadens";
    email = "labadens.pierre+nixpkgs@gmail.com";
    github = "plabadens";
    githubId = 4303706;
    keys = [{
      fingerprint = "B00F E582 FD3F 0732 EA48  3937 F558 14E4 D687 4375";
    }];
  };
  PlayerNameHere = {
    name = "Dixon Sean Low Yan Feng";
    email = "dixonseanlow@protonmail.com";
    github = "PlayerNameHere";
    githubId = 56017218;
    keys = [{
      fingerprint = "E6F4 BFB4 8DE3 893F 68FC  A15F FF5F 4B30 A41B BAC8";
    }];
  };
  plchldr = {
    email = "mail@oddco.de";
    github = "plchldr";
    githubId = 11639001;
    name = "Jonas Beyer";
  };
  plcplc = {
    email = "plcplc@gmail.com";
    github = "plcplc";
    githubId = 358550;
    name = "Philip Lykke Carlsen";
  };
  pleshevskiy = {
    email = "dmitriy@pleshevski.ru";
    github = "pleshevskiy";
    githubId = 7839004;
    name = "Dmitriy Pleshevskiy";
  };
  plumps = {
    email = "maks.bronsky@web.de";
    github = "plumps";
    githubId = 13000278;
    name = "Maksim Bronsky";
  };
  PlushBeaver = {
    name = "Dmitry Kozlyuk";
    email = "dmitry.kozliuk+nixpkgs@gmail.com";
    github = "PlushBeaver";
    githubId = 8988269;
  };
  pmahoney = {
    email = "pat@polycrystal.org";
    github = "pmahoney";
    githubId = 103822;
    name = "Patrick Mahoney";
  };
  pmenke = {
    email = "nixos@pmenke.de";
    github = "pmenke-de";
    githubId = 898922;
    name = "Philipp Menke";
    keys = [{
      fingerprint = "ED54 5EFD 64B6 B5AA EC61 8C16 EB7F 2D4C CBE2 3B69";
    }];
  };
  pmeunier = {
    email = "pierre-etienne.meunier@inria.fr";
    github = "P-E-Meunier";
    githubId = 17021304;
    name = "Pierre-Étienne Meunier";
  };
  pmiddend = {
    email = "pmidden@secure.mailbox.org";
    github = "pmiddend";
    githubId = 178496;
    name = "Philipp Middendorf";
  };
  pmw = {
    email = "philip@mailworks.org";
    matrix = "@philip4g:matrix.org";
    name = "Philip White";
    github = "philipmw";
    githubId = 1379645;
    keys = [{
      fingerprint = "9AB0 6C94 C3D1 F9D0 B9D9  A832 BC54 6FB3 B16C 8B0B";
    }];
  };
  pmy = {
    email = "pmy@xqzp.net";
    github = "pmeiyu";
    githubId = 8529551;
    name = "Peng Mei Yu";
  };
  pmyjavec = {
    email = "pauly@myjavec.com";
    github = "pmyjavec";
    githubId = 315096;
    name = "Pauly Myjavec";
  };
  pnelson = {
    email = "me@pnelson.ca";
    github = "pnelson";
    githubId = 579773;
    name = "Philip Nelson";
  };
  pneumaticat = {
    email = "kevin@potatofrom.space";
    github = "kliu128";
    githubId = 11365056;
    name = "Kevin Liu";
  };
  pnmadelaine = {
    name = "Paul-Nicolas Madelaine";
    email = "pnm@pnm.tf";
    github = "pnmadelaine";
    githubId = 21977014;
  };
  pnotequalnp = {
    email = "kevin@pnotequalnp.com";
    github = "pnotequalnp";
    githubId = 46154511;
    name = "Kevin Mullins";
    keys = [{
      fingerprint = "2CD2 B030 BD22 32EF DF5A  008A 3618 20A4 5DB4 1E9A";
    }];
  };
  podocarp = {
    email = "xdjiaxd@gmail.com";
    github = "podocarp";
    githubId = 10473184;
    name = "Jia Xiaodong";
  };
  pogobanane = {
    email = "mail@peter-okelmann.de";
    github = "pogobanane";
    githubId = 38314551;
    name = "Peter Okelmann";
  };
  polarmutex = {
    email = "brian@brianryall.xyz";
    github = "polarmutex";
    githubId = 115141;
    name = "Brian Ryall";
  };
  polendri = {
    email = "paul@ijj.li";
    github = "polendri";
    githubId = 1829032;
    name = "Paul Hendry";
  };
  polygon = {
    email = "polygon@wh2.tu-dresden.de";
    name = "Polygon";
    github = "polygon";
    githubId = 51489;
  };
  polykernel = {
    email = "81340136+polykernel@users.noreply.github.com";
    github = "polykernel";
    githubId = 81340136;
    name = "polykernel";
  };
  poelzi = {
    email = "nix@poelzi.org";
    github = "poelzi";
    githubId = 66107;
    name = "Daniel Poelzleithner";
  };
  polyrod = {
    email = "dc1mdp@gmail.com";
    github = "polyrod";
    githubId = 24878306;
    name = "Maurizio Di Pietro";
  };
  pombeirp = {
    email = "nix@endgr.33mail.com";
    github = "pedropombeiro";
    githubId = 138074;
    name = "Pedro Pombeiro";
  };
  poscat = {
    email = "poscat@mail.poscat.moe";
    github = "poscat0x04";
    githubId = 53291983;
    name = "Poscat Tarski";
    keys = [{
      fingerprint = "48AD DE10 F27B AFB4 7BB0  CCAF 2D25 95A0 0D08 ACE0";
    }];
  };
  posch = {
    email = "tp@fonz.de";
    github = "posch";
    githubId = 146413;
    name = "Tobias Poschwatta";
  };
  ppenguin = {
    name = "Jeroen Versteeg";
    email = "hieronymusv@gmail.com";
    github = "ppenguin";
    githubId = 17690377;
  };
  ppom = {
    name = "Paco Pompeani";
    email = "paco@ecomail.io";
    github = "aopom";
    githubId = 38916722;
  };
  pradeepchhetri = {
    email = "pradeep.chhetri89@gmail.com";
    github = "pradeepchhetri";
    githubId = 2232667;
    name = "Pradeep Chhetri";
  };
  pradyuman = {
    email = "me@pradyuman.co";
    github = "pradyuman";
    githubId = 9904569;
    name = "Pradyuman Vig";
    keys = [{
      fingerprint = "240B 57DE 4271 2480 7CE3  EAC8 4F74 D536 1C4C A31E";
    }];
  };
  preisschild = {
    email = "florian@florianstroeger.com";
    github = "Preisschild";
    githubId = 11898437;
    name = "Florian Ströger";
  };
  priegger = {
    email = "philipp@riegger.name";
    github = "priegger";
    githubId = 228931;
    name = "Philipp Riegger";
  };
  prikhi = {
    email = "pavan.rikhi@gmail.com";
    github = "prikhi";
    githubId = 1304102;
    name = "Pavan Rikhi";
  };
  primeos = {
    email = "dev.primeos@gmail.com";
    matrix = "@primeos:matrix.org";
    github = "primeos";
    githubId = 7537109;
    name = "Michael Weiss";
    keys = [
      {
        # Git only
        fingerprint = "86A7 4A55 07D0 58D1 322E  37FD 1308 26A6 C2A3 89FD";
      }
      {
        # Email, etc.
        fingerprint = "AF85 991C C950 49A2 4205  1933 BCA9 943D D1DF 4C04";
      }
    ];
  };
  prtzl = {
    email = "matej.blagsic@protonmail.com";
    github = "prtzl";
    githubId = 32430344;
    name = "Matej Blagsic";
  };
  ProducerMatt = {
    name = "Matthew Pherigo";
    email = "ProducerMatt42@gmail.com";
    github = "ProducerMatt";
    githubId = 58014742;
  };
  Profpatsch = {
    email = "mail@profpatsch.de";
    github = "Profpatsch";
    githubId = 3153638;
    name = "Profpatsch";
  };
  proglodyte = {
    email = "proglodyte23@gmail.com";
    github = "proglodyte";
    githubId = 18549627;
    name = "Proglodyte";
  };
  progval = {
    email = "progval+nix@progval.net";
    github = "progval";
    githubId = 406946;
    name = "Valentin Lorentz";
  };
  proofofkeags = {
    email = "keagan.mcclelland@gmail.com";
    github = "ProofOfKeags";
    githubId = 4033651;
    name = "Keagan McClelland";
  };
  protoben = {
    email = "protob3n@gmail.com";
    github = "protoben";
    githubId = 4633847;
    name = "Ben Hamlin";
  };
  prusnak = {
    email = "pavol@rusnak.io";
    github = "prusnak";
    githubId = 42201;
    name = "Pavol Rusnak";
    keys = [{
      fingerprint = "86E6 792F C27B FD47 8860  C110 91F3 B339 B9A0 2A3D";
    }];
  };
  psanford = {
    email = "psanford@sanford.io";
    github = "psanford";
    githubId = 33375;
    name = "Peter Sanford";
  };
  pshirshov = {
    email = "pshirshov@eml.cc";
    github = "pshirshov";
    githubId = 295225;
    name = "Pavel Shirshov";
  };
  psibi = {
    email = "sibi@psibi.in";
    matrix = "@psibi:matrix.org";
    github = "psibi";
    githubId = 737477;
    name = "Sibi Prabakaran";
  };
  pstn = {
    email = "philipp@xndr.de";
    github = "pstn";
    githubId = 1329940;
    name = "Philipp Steinpaß";
  };
  pSub = {
    email = "mail@pascal-wittmann.de";
    github = "pSub";
    githubId = 83842;
    name = "Pascal Wittmann";
  };
  psyanticy = {
    email = "iuns@outlook.fr";
    github = "PsyanticY";
    githubId = 20524473;
    name = "Psyanticy";
  };
  psydvl = {
    email = "psydvl@fea.st";
    github = "psydvl";
    githubId = 43755002;
    name = "Dmitriy P";
  };
  ptival = {
    email = "valentin.robert.42@gmail.com";
    github = "Ptival";
    githubId = 478606;
    name = "Valentin Robert";
  };
  ptrhlm = {
    email = "ptrhlm0@gmail.com";
    github = "ptrhlm";
    githubId = 9568176;
    name = "Piotr Halama";
  };
  puckipedia = {
    email = "puck@puckipedia.com";
    github = "puckipedia";
    githubId = 488734;
    name = "Puck Meerburg";
  };
  puffnfresh = {
    email = "brian@brianmckenna.org";
    github = "puffnfresh";
    githubId = 37715;
    name = "Brian McKenna";
  };
  purcell = {
    email = "steve@sanityinc.com";
    github = "purcell";
    githubId = 5636;
    name = "Steve Purcell";
  };
  putchar = {
    email = "slim.cadoux@gmail.com";
    matrix = "@putch4r:matrix.org";
    github = "putchar";
    githubId = 8208767;
    name = "Slim Cadoux";
  };
  puzzlewolf = {
    email = "nixos@nora.pink";
    github = "puzzlewolf";
    githubId = 23097564;
    name = "Nora Widdecke";
  };
  pyrolagus = {
    email = "pyrolagus@gmail.com";
    github = "PyroLagus";
    githubId = 4579165;
    name = "Danny Bautista";
  };
  peelz = {
    email = "peelz.dev+nixpkgs@gmail.com";
    github = "notpeelz";
    githubId = 920910;
    name = "peelz";
  };
  q3k = {
    email = "q3k@q3k.org";
    github = "q3k";
    githubId = 315234;
    name = "Serge Bazanski";
  };
  qknight = {
    email = "js@lastlog.de";
    github = "qknight";
    githubId = 137406;
    name = "Joachim Schiele";
  };
  qoelet = {
    email = "kenny@machinesung.com";
    github = "qoelet";
    githubId = 115877;
    name = "Kenny Shen";
  };
  quag = {
    email = "quaggy@gmail.com";
    github = "quag";
    githubId = 35086;
    name = "Jonathan Wright";
  };
  quantenzitrone = {
    email = "quantenzitrone@protonmail.com";
    github = "Quantenzitrone";
    githubId = 74491719;
    matrix = "@quantenzitrone:matrix.org";
    name = "quantenzitrone";
  };
  queezle = {
    email = "git@queezle.net";
    github = "queezle42";
    githubId = 1024891;
    name = "Jens Nolte";
  };
  quentini = {
    email = "quentini@airmail.cc";
    github = "QuentinI";
    githubId = 18196237;
    name = "Quentin Inkling";
  };
  qyliss = {
    email = "hi@alyssa.is";
    github = "alyssais";
    githubId = 2768870;
    name = "Alyssa Ross";
    keys = [{
      fingerprint = "7573 56D7 79BB B888 773E  415E 736C CDF9 EF51 BD97";
    }];
  };
  r-burns = {
    email = "rtburns@protonmail.com";
    github = "r-burns";
    githubId = 52847440;
    name = "Ryan Burns";
  };
  r3dl3g = {
    email = "redleg@rothfuss-web.de";
    github = "r3dl3g";
    githubId = 35229674;
    name = "Armin Rothfuss";
  };
  raboof = {
    email = "arnout@bzzt.net";
    matrix = "@raboof:matrix.org";
    github = "raboof";
    githubId = 131856;
    name = "Arnout Engelen";
  };
  rafael = {
    name = "Rafael";
    email = "pr9@tuta.io";
    github = "rafa-dot-el";
    githubId = 104688305;
    keys = [{
      fingerprint = "5F0B 3EAC F1F9 8155 0946 CDF5 469E 3255 A40D 2AD6";
    }];
  };
  RaghavSood = {
    email = "r@raghavsood.com";
    github = "RaghavSood";
    githubId = 903072;
    name = "Raghav Sood";
  };
  rafaelgg = {
    email = "rafael.garcia.gallego@gmail.com";
    github = "rafaelgg";
    githubId = 1016742;
    name = "Rafael García";
  };
  raitobezarius = {
    email = "ryan@lahfa.xyz";
    matrix = "@raitobezarius:matrix.org";
    github = "RaitoBezarius";
    githubId = 314564;
    name = "Ryan Lahfa";
  };
  raphaelr = {
    email = "raphael-git@tapesoftware.net";
    matrix = "@raphi:tapesoftware.net";
    github = "raphaelr";
    githubId = 121178;
    name = "Raphael Robatsch";
  };
  raquelgb = {
    email = "raquel.garcia.bautista@gmail.com";
    github = "raquelgb";
    githubId = 1246959;
    name = "Raquel García";
  };
  ragge = {
    email = "r.dahlen@gmail.com";
    github = "ragnard";
    githubId = 882;
    name = "Ragnar Dahlen";
  };
  ralith = {
    email = "ben.e.saunders@gmail.com";
    matrix = "@ralith:ralith.com";
    github = "Ralith";
    githubId = 104558;
    name = "Benjamin Saunders";
  };
  ramkromberg = {
    email = "ramkromberg@mail.com";
    github = "RamKromberg";
    githubId = 14829269;
    name = "Ram Kromberg";
  };
  ranfdev = {
    email = "ranfdev@gmail.com";
    name = "Lorenzo Miglietta";
    github = "ranfdev";
    githubId = 23294184;
  };
  rardiol = {
    email = "ricardo.ardissone@gmail.com";
    github = "rardiol";
    githubId = 11351304;
    name = "Ricardo Ardissone";
  };
  rasendubi = {
    email = "rasen.dubi@gmail.com";
    github = "rasendubi";
    githubId = 1366419;
    name = "Alexey Shmalko";
  };
  raskin = {
    email = "7c6f434c@mail.ru";
    github = "7c6f434c";
    githubId = 1891350;
    name = "Michael Raskin";
  };
  ratsclub = {
    email = "victor@freire.dev.br";
    github = "vtrf";
    githubId = 25647735;
    name = "Victor Freire";
  };
  rawkode = {
    email = "david.andrew.mckay@gmail.com";
    github = "rawkode";
    githubId = 145816;
    name = "David McKay";
  };
  razvan = {
    email = "razvan.panda@gmail.com";
    github = "razvan-flavius-panda";
    githubId = 1758708;
    name = "Răzvan Flavius Panda";
  };
  rb2k = {
    email = "nix@marc-seeger.com";
    github = "rb2k";
    githubId = 9519;
    name = "Marc Seeger";
  };
  rbasso = {
    email = "rbasso@sharpgeeks.net";
    github = "rbasso";
    githubId = 16487165;
    name = "Rafael Basso";
  };
  rbreslow = {
    name = "Rocky Breslow";
    email = "1774125+rbreslow@users.noreply.github.com";
    github = "rbreslow";
    githubId = 1774125;
    keys = [{
      fingerprint = "B5B7 BCA0 EE6F F31E 263A  69E3 A0D3 2ACC A38B 88ED";
    }];
  };
  rbrewer = {
    email = "rwb123@gmail.com";
    github = "rbrewer123";
    githubId = 743058;
    name = "Rob Brewer";
  };
  rdnetto = {
    email = "rdnetto@gmail.com";
    github = "rdnetto";
    githubId = 1973389;
    name = "Reuben D'Netto";
  };
  realsnick = {
    name = "Ido Samuelson";
    email = "ido.samuelson@gmail.com";
    github = "realsnick";
    githubId = 1440852;
  };
  redbaron = {
    email = "ivanov.maxim@gmail.com";
    github = "redbaron";
    githubId = 16624;
    name = "Maxim Ivanov";
  };
  reckenrode = {
    name = "Randy Eckenrode";
    email = "randy@largeandhighquality.com";
    matrix = "@reckenrode:matrix.org";
    github = "reckenrode";
    githubId = 7413633;
    keys = [
      # compare with https://keybase.io/reckenrode
      {
        fingerprint = "01D7 5486 3A6D 64EA AC77 0D26 FBF1 9A98 2CCE 0048";
      }
    ];
  };
  redfish64 = {
    email = "engler@gmail.com";
    github = "redfish64";
    githubId = 1922770;
    name = "Tim Engler";
  };
  redvers = {
    email = "red@infect.me";
    github = "redvers";
    githubId = 816465;
    name = "Redvers Davies";
  };
  reedrw = {
    email = "reedrw5601@gmail.com";
    github = "reedrw";
    githubId = 21069876;
    name = "Reed Williams";
  };
  refnil = {
    email = "broemartino@gmail.com";
    github = "refnil";
    githubId = 1142322;
    name = "Martin Lavoie";
  };
  regadas = {
    email = "oss@regadas.email";
    name = "Filipe Regadas";
    github = "regadas";
    githubId = 163899;
  };
  regnat = {
    email = "regnat@regnat.ovh";
    github = "thufschmitt";
    githubId = 7226587;
    name = "Théophane Hufschmitt";
  };
  rehno-lindeque = {
    email = "rehno.lindeque+code@gmail.com";
    github = "rehno-lindeque";
    githubId = 337811;
    name = "Rehno Lindeque";
  };
  relrod = {
    email = "ricky@elrod.me";
    github = "relrod";
    githubId = 43930;
    name = "Ricky Elrod";
  };
  rembo10 = {
    email = "rembo10@users.noreply.github.com";
    github = "rembo10";
    githubId = 801525;
    name = "rembo10";
  };
  renatoGarcia = {
    email = "fgarcia.renato@gmail.com";
    github = "renatoGarcia";
    githubId = 220211;
    name = "Renato Garcia";
  };
  rencire = {
    email = "546296+rencire@users.noreply.github.com";
    github = "rencire";
    githubId = 546296;
    name = "Eric Ren";
  };
  renesat = {
    name = "Ivan Smolyakov";
    email = "smol.ivan97@gmail.com";
    github = "renesat";
    githubId = 11363539;
  };
  renzo = {
    email = "renzocarbonara@gmail.com";
    github = "k0001";
    githubId = 3302;
    name = "Renzo Carbonara";
  };
  retrry = {
    email = "retrry@gmail.com";
    github = "retrry";
    githubId = 500703;
    name = "Tadas Barzdžius";
  };
  revol-xut = {
    email = "revol-xut@protonmail.com";
    name = "Tassilo Tanneberger";
    github = "revol-xut";
    githubId = 32239737;
    keys = [{
      fingerprint = "91EB E870 1639 1323 642A  6803 B966 009D 57E6 9CC6";
    }];
  };
  rexim = {
    email = "reximkut@gmail.com";
    github = "rexim";
    githubId = 165283;
    name = "Alexey Kutepov";
  };
  rewine = {
    email = "lhongxu@outlook.com";
    github = "wineee";
    githubId = 22803888;
    name = "Lu Hongxu";
  };
  rgnns = {
    email = "jglievano@gmail.com";
    github = "rgnns";
    githubId = 811827;
    name = "Gabriel Lievano";
  };
  rgrinberg = {
    name = "Rudi Grinberg";
    email = "me@rgrinberg.com";
    github = "rgrinberg";
    githubId = 139003;
  };
  rgrunbla = {
    email = "remy@grunblatt.org";
    github = "rgrunbla";
    githubId = 42433779;
    name = "Rémy Grünblatt";
  };
  rguevara84 = {
    email = "fuzztkd@gmail.com";
    github = "rguevara84";
    githubId = 12279531;
    name = "Ricardo Guevara";
  };
  rht = {
    email = "rhtbot@protonmail.com";
    github = "rht";
    githubId = 395821;
    name = "rht";
  };
  rhoriguchi = {
    email = "ryan.horiguchi@gmail.com";
    github = "rhoriguchi";
    githubId = 6047658;
    name = "Ryan Horiguchi";
  };
  rhysmdnz = {
    email = "rhys@memes.nz";
    matrix = "@rhys:memes.nz";
    github = "rhysmdnz";
    githubId = 2162021;
    name = "Rhys Davies";
  };
  ribose-jeffreylau = {
    name = "Jeffrey Lau";
    email = "jeffrey.lau@ribose.com";
    github = "ribose-jeffreylau";
    githubId = 2649467;
  };
  richardipsum = {
    email = "richardipsum@fastmail.co.uk";
    github = "richardipsum";
    githubId = 10631029;
    name = "Richard Ipsum";
  };
  rick68 = {
    email = "rick68@gmail.com";
    github = "rick68";
    githubId = 42619;
    name = "Wei-Ming Yang";
  };
  rickynils = {
    email = "rickynils@gmail.com";
    github = "rickynils";
    githubId = 16779;
    name = "Rickard Nilsson";
  };
  ricochet = {
    email = "behayes2@gmail.com";
    github = "ricochet";
    githubId = 974323;
    matrix = "@ricochetcode:matrix.org";
    name = "Bailey Hayes";
  };
  riey = {
    email = "creeper844@gmail.com";
    github = "Riey";
    githubId = 14910534;
    name = "Riey";
  };
  rika = {
    email = "rika@paymentswit.ch";
    github = "NekomimiScience";
    githubId = 1810487;
    name = "Rika";
  };
  rileyinman = {
    email = "rileyminman@gmail.com";
    github = "rileyinman";
    githubId = 37246692;
    name = "Riley Inman";
  };
  riotbib = {
    email = "github-nix@lnrt.de";
    github = "riotbib";
    githubId = 43172581;
    name = "Lennart Mühlenmeier";
  };
  ris = {
    email = "code@humanleg.org.uk";
    github = "risicle";
    githubId = 807447;
    name = "Robert Scott";
  };
  risson = {
    name = "Marc Schmitt";
    email = "marc.schmitt@risson.space";
    matrix = "@risson:lama-corp.space";
    github = "rissson";
    githubId = 18313093;
    keys = [
      {
        fingerprint = "8A0E 6A7C 08AB B9DE 67DE  2A13 F6FD 87B1 5C26 3EC9";
      }
      {
        fingerprint = "C0A7 A9BB 115B C857 4D75  EA99 BBB7 A680 1DF1 E03F";
      }
    ];
  };
  rixed = {
    email = "rixed-github@happyleptic.org";
    github = "rixed";
    githubId = 449990;
    name = "Cedric Cellier";
  };
  rkitover = {
    email = "rkitover@gmail.com";
    github = "rkitover";
    githubId = 77611;
    name = "Rafael Kitover";
  };
  rkoe = {
    email = "rk@simple-is-better.org";
    github = "rkoe";
    githubId = 2507744;
    name = "Roland Koebler";
  };
  rizary = {
    email = "andika@numtide.com";
    github = "Rizary";
    githubId = 7221768;
    name = "Andika Demas Riyandi";
  };
  rkrzr = {
    email = "ops+nixpkgs@channable.com";
    github = "rkrzr";
    githubId = 82817;
    name = "Robert Kreuzer";
  };
  rlupton20 = {
    email = "richard.lupton@gmail.com";
    github = "rlupton20";
    githubId = 13752145;
    name = "Richard Lupton";
  };
  rmcgibbo = {
    email = "rmcgibbo@gmail.com";
    matrix = "@rmcgibbo:matrix.org";
    github = "rmcgibbo";
    githubId = 641278;
    name = "Robert T. McGibbon";
  };
  rnhmjoj = {
    email = "rnhmjoj@inventati.org";
    matrix = "@rnhmjoj:maxwell.ydns.eu";
    github = "rnhmjoj";
    githubId = 2817565;
    name = "Michele Guerini Rocco";
    keys = [{
      fingerprint = "92B2 904F D293 C94D C4C9  3E6B BFBA F4C9 75F7 6450";
    }];
  };
  roastiek = {
    email = "r.dee.b.b@gmail.com";
    github = "roastiek";
    githubId = 422802;
    name = "Rostislav Beneš";
  };
  rob = {
    email = "rob.vermaas@gmail.com";
    github = "rbvermaa";
    githubId = 353885;
    name = "Rob Vermaas";
  };
  robaca = {
    email = "carsten@r0hrbach.de";
    github = "robaca";
    githubId = 580474;
    name = "Carsten Rohrbach";
  };
  robberer = {
    email = "robberer@freakmail.de";
    github = "robberer";
    githubId = 6204883;
    name = "Longrin Wischnewski";
  };
  robbinch = {
    email = "robbinch33@gmail.com";
    github = "robbinch";
    githubId = 12312980;
    name = "Robbin C.";
  };
  robbins = {
    email = "nejrobbins@gmail.com";
    github = "robbins";
    githubId = 31457698;
    name = "Nathanael Robbins";
  };
  roberth = {
    email = "nixpkgs@roberthensing.nl";
    matrix = "@roberthensing:matrix.org";
    github = "roberth";
    githubId = 496447;
    name = "Robert Hensing";
  };
  robertodr = {
    email = "roberto.diremigio@gmail.com";
    github = "robertodr";
    githubId = 3708689;
    name = "Roberto Di Remigio";
  };
  robertoszek = {
    email = "robertoszek@robertoszek.xyz";
    github = "robertoszek";
    githubId = 1080963;
    name = "Roberto";
  };
  robgssp = {
    email = "robgssp@gmail.com";
    github = "robgssp";
    githubId = 521306;
    name = "Rob Glossop";
  };
  roblabla = {
    email = "robinlambertz+dev@gmail.com";
    github = "roblabla";
    githubId = 1069318;
    name = "Robin Lambertz";
  };
  roconnor = {
    email = "roconnor@theorem.ca";
    github = "roconnor";
    githubId = 852967;
    name = "Russell O'Connor";
  };
  rodrgz = {
    email = "erik@rodgz.com";
    github = "rodrgz";
    githubId = 53882428;
    name = "Erik Rodriguez";
  };
  roelvandijk = {
    email = "roel@lambdacube.nl";
    github = "roelvandijk";
    githubId = 710906;
    name = "Roel van Dijk";
  };
  romildo = {
    email = "malaquias@gmail.com";
    github = "romildo";
    githubId = 1217934;
    name = "José Romildo Malaquias";
  };
  ronanmacf = {
    email = "macfhlar@tcd.ie";
    github = "RonanMacF";
    githubId = 25930627;
    name = "Ronan Mac Fhlannchadha";
  };
  rongcuid = {
    email = "rongcuid@outlook.com";
    github = "rongcuid";
    githubId = 1312525;
    name = "Rongcui Dong";
  };
  roosemberth = {
    email = "roosembert.palacios+nixpkgs@posteo.ch";
    matrix = "@roosemberth:orbstheorem.ch";
    github = "roosemberth";
    githubId = 3621083;
    name = "Roosembert (Roosemberth) Palacios";
    keys = [{
      fingerprint = "78D9 1871 D059 663B 6117  7532 CAAA ECE5 C224 2BB7";
    }];
  };
  rople380 = {
    name = "rople380";
    email = "55679162+rople380@users.noreply.github.com";
    github = "rople380";
    githubId = 55679162;
    keys = [{
      fingerprint = "1401 1B63 393D 16C1 AA9C  C521 8526 B757 4A53 6236";
    }];
  };
  rowanG077 = {
    email = "goemansrowan@gmail.com";
    github = "rowanG077";
    githubId = 7439756;
    name = "Rowan Goemans";
  };
  royneary = {
    email = "christian@ulrich.earth";
    github = "royneary";
    githubId = 1942810;
    name = "Christian Ulrich";
  };
  rpearce = {
    email = "me@robertwpearce.com";
    github = "rpearce";
    githubId = 592876;
    name = "Robert W. Pearce";
  };
  rprecenth = {
    email = "rasmus@precenth.eu";
    github = "Prillan";
    githubId = 1675190;
    name = "Rasmus Précenth";
  };
  rprospero = {
    email = "rprospero+nix@gmail.com";
    github = "rprospero";
    githubId = 1728853;
    name = "Adam Washington";
  };
  rps = {
    email = "robbpseaton@gmail.com";
    github = "robertseaton";
    githubId = 221121;
    name = "Robert P. Seaton";
  };
  rraval = {
    email = "ronuk.raval@gmail.com";
    github = "rraval";
    githubId = 373566;
    name = "Ronuk Raval";
  };
  rrbutani = {
    email = "rrbutani+nix@gmail.com";
    github = "rrbutani";
    githubId = 7833358;
    keys = [{
      fingerprint = "7DCA 5615 8AB2 621F 2F32  9FF4 1C7C E491 479F A273";
    }];
    name = "Rahul Butani";
  };
  rski = {
    name = "rski";
    email = "rom.skiad+nix@gmail.com";
    github = "rski";
    githubId = 2960312;
  };
  rszibele = {
    email = "richard@szibele.com";
    github = "rszibele";
    githubId = 1387224;
    name = "Richard Szibele";
  };
  rsynnest = {
    email = "contact@rsynnest.com";
    github = "rsynnest";
    githubId = 4392850;
    name = "Roland Synnestvedt";
  };
  rtburns-jpl = {
    email = "rtburns@jpl.nasa.gov";
    github = "rtburns-jpl";
    githubId = 47790121;
    name = "Ryan Burns";
  };
  rtreffer = {
    email = "treffer+nixos@measite.de";
    github = "rtreffer";
    githubId = 61306;
    name = "Rene Treffer";
  };
  rushmorem = {
    email = "rushmore@webenchanter.com";
    github = "rushmorem";
    githubId = 4958190;
    name = "Rushmore Mushambi";
  };
  russell = {
    email = "russell.sim@gmail.com";
    github = "russell";
    githubId = 2660;
    name = "Russell Sim";
  };
  ruuda = {
    email = "dev+nix@veniogames.com";
    github = "ruuda";
    githubId = 506953;
    name = "Ruud van Asseldonk";
  };
  rvarago = {
    email = "rafael.varago@gmail.com";
    github = "rvarago";
    githubId = 7365864;
    name = "Rafael Varago";
  };
  rvl = {
    email = "dev+nix@rodney.id.au";
    github = "rvl";
    githubId = 1019641;
    name = "Rodney Lorrimar";
  };
  rvlander = {
    email = "rvlander@gaetanandre.eu";
    github = "rvlander";
    githubId = 5236428;
    name = "Gaëtan André";
  };
  rvolosatovs = {
    email = "rvolosatovs@riseup.net";
    github = "rvolosatovs";
    githubId = 12877905;
    name = "Roman Volosatovs";
  };
  ryanartecona = {
    email = "ryanartecona@gmail.com";
    github = "ryanartecona";
    githubId = 889991;
    name = "Ryan Artecona";
  };
  ryanorendorff = {
    email = "12442942+ryanorendorff@users.noreply.github.com";
    github = "ryanorendorff";
    githubId = 12442942;
    name = "Ryan Orendorff";
  };
  ryansydnor = {
    email = "ryan.t.sydnor@gmail.com";
    github = "ryansydnor";
    githubId = 1832096;
    name = "Ryan Sydnor";
  };
  ryantm = {
    email = "ryan@ryantm.com";
    matrix = "@ryantm:matrix.org";
    github = "ryantm";
    githubId = 4804;
    name = "Ryan Mulligan";
  };
  ryantrinkle = {
    email = "ryan.trinkle@gmail.com";
    github = "ryantrinkle";
    githubId = 1156448;
    name = "Ryan Trinkle";
  };
  rybern = {
    email = "ryan.bernstein@columbia.edu";
    github = "rybern";
    githubId = 4982341;
    name = "Ryan Bernstein";
  };
  rycee = {
    email = "robert@rycee.net";
    github = "rycee";
    githubId = 798147;
    name = "Robert Helgesson";
    keys = [{
      fingerprint = "36CA CF52 D098 CC0E 78FB  0CB1 3573 356C 25C4 24D4";
    }];
  };
  ryneeverett = {
    email = "ryneeverett@gmail.com";
    github = "ryneeverett";
    githubId = 3280280;
    name = "Ryne Everett";
  };
  rytone = {
    email = "max@ryt.one";
    github = "rastertail";
    githubId = 8082305;
    name = "Maxwell Beck";
    keys = [{
      fingerprint = "D260 79E3 C2BC 2E43 905B  D057 BB3E FA30 3760 A0DB";
    }];
  };
  rzetterberg = {
    email = "richard.zetterberg@gmail.com";
    github = "rzetterberg";
    githubId = 766350;
    name = "Richard Zetterberg";
  };
  s1341 = {
    email = "s1341@shmarya.net";
    matrix = "@s1341:matrix.org";
    name = "Shmarya Rubenstein";
    github = "s1341";
    githubId = 5682183;
  };
  sagikazarmark = {
    name = "Mark Sagi-Kazar";
    email = "mark.sagikazar@gmail.com";
    matrix = "@mark.sagikazar:matrix.org";
    github = "sagikazarmark";
    githubId = 1226384;
    keys = [{
      fingerprint = "E628 C811 6FB8 1657 F706  4EA4 F251 ADDC 9D04 1C7E";
    }];
  };
  samalws = {
    email = "sam@samalws.com";
    name = "Sam Alws";
    github = "samalws";
    githubId = 20981725;
  };
  samb96 = {
    email = "samb96@gmail.com";
    github = "samb96";
    githubId = 819426;
    name = "Sam Bickley";
  };
  samdoshi = {
    email = "sam@metal-fish.co.uk";
    github = "samdoshi";
    githubId = 112490;
    name = "Sam Doshi";
  };
  samdroid-apps = {
    email = "sam@sam.today";
    github = "samdroid-apps";
    githubId = 6022042;
    name = "Sam Parkinson";
  };
  samlich = {
    email = "nixos@samli.ch";
    github = "samlich";
    githubId = 1349989;
    name = "samlich";
    keys = [{
      fingerprint = "AE8C 0836 FDF6 3FFC 9580  C588 B156 8953 B193 9F1C";
    }];
  };
  samlukeyes123 = {
    email = "samlukeyes123@gmail.com";
    github = "SamLukeYes";
    githubId = 12882091;
    name = "Sam L. Yes";
  };
  samrose = {
    email = "samuel.rose@gmail.com";
    github = "samrose";
    githubId = 115821;
    name = "Sam Rose";
  };
  samuela = {
    email = "skainsworth@gmail.com";
    github = "samuela";
    githubId = 226872;
    name = "Samuel Ainsworth";
  };
  samueldr = {
    email = "samuel@dionne-riel.com";
    matrix = "@samueldr:matrix.org";
    github = "samueldr";
    githubId = 132835;
    name = "Samuel Dionne-Riel";
  };
  samuelrivas = {
    email = "samuelrivas@gmail.com";
    github = "samuelrivas";
    githubId = 107703;
    name = "Samuel Rivas";
  };
  samw = {
    email = "sam@wlcx.cc";
    github = "wlcx";
    githubId = 3065381;
    name = "Sam Willcocks";
  };
  samyak = {
    name = "Samyak Sarnayak";
    email = "samyak201@gmail.com";
    github = "Samyak2";
    githubId = 34161949;
    keys = [{
      fingerprint = "155C F413 0129 C058 9A5F  5524 3658 73F2 F0C6 153B";
    }];
  };
  sander = {
    email = "s.vanderburg@tudelft.nl";
    github = "svanderburg";
    githubId = 1153271;
    name = "Sander van der Burg";
  };
  sarcasticadmin = {
    email = "rob@sarcasticadmin.com";
    github = "sarcasticadmin";
    githubId = 30531572;
    name = "Robert James Hernandez";
  };
  sargon = {
    email = "danielehlers@mindeye.net";
    github = "sargon";
    githubId = 178904;
    name = "Daniel Ehlers";
  };
  saschagrunert = {
    email = "mail@saschagrunert.de";
    github = "saschagrunert";
    githubId = 695473;
    name = "Sascha Grunert";
  };
  sauyon = {
    email = "s@uyon.co";
    github = "sauyon";
    githubId = 2347889;
    name = "Sauyon Lee";
  };
  savannidgerinel = {
    email = "savanni@luminescent-dreams.com";
    github = "savannidgerinel";
    githubId = 8534888;
    name = "Savanni D'Gerinel";
  };
  sayanarijit = {
    email = "sayanarijit@gmail.com";
    github = "sayanarijit";
    githubId = 11632726;
    name = "Arijit Basu";
  };
  sb0 = {
    email = "sb@m-labs.hk";
    github = "sbourdeauducq";
    githubId = 720864;
    name = "Sébastien Bourdeauducq";
  };
  sbellem = {
    email = "sbellem@gmail.com";
    github = "sbellem";
    githubId = 125458;
    name = "Sylvain Bellemare";
  };
  sbond75 = {
    name = "sbond75";
    email = "43617712+sbond75@users.noreply.github.com";
    github = "sbond75";
    githubId = 43617712;
  };
  sboosali = {
    email = "SamBoosalis@gmail.com";
    github = "sboosali";
    githubId = 2320433;
    name = "Sam Boosalis";
  };
  sbruder = {
    email = "nixos@sbruder.de";
    github = "sbruder";
    githubId = 15986681;
    name = "Simon Bruder";
  };
  scalavision = {
    email = "scalavision@gmail.com";
    github = "scalavision";
    githubId = 3958212;
    name = "Tom Sorlie";
  };
  sioodmy = {
    name = "Antoni Sokołowski";
    email = "81568712+sioodmy@users.noreply.github.com";
    github = "sioodmy";
    githubId = 81568712;
  };
  siph = {
    name = "Chris Dawkins";
    email = "dawkins.chris.dev@gmail.com";
    github = "siph";
    githubId = 6619112;
  };
  schmitthenner = {
    email = "development@schmitthenner.eu";
    github = "fkz";
    githubId = 354463;
    name = "Fabian Schmitthenner";
  };
  schmittlauch = {
    name = "Trolli Schmittlauch";
    email = "t.schmittlauch+nixos@orlives.de";
    github = "schmittlauch";
    githubId = 1479555;
  };
  schneefux = {
    email = "schneefux+nixos_pkg@schneefux.xyz";
    github = "schneefux";
    githubId = 15379000;
    name = "schneefux";
  };
  schnusch = {
    email = "schnusch@users.noreply.github.com";
    github = "schnusch";
    githubId = 5104601;
    name = "schnusch";
  };
  sciencentistguy = {
    email = "jamie@quigley.xyz";
    name = "Jamie Quigley";
    github = "Sciencentistguy";
    githubId = 4983935;
    keys = [{
      fingerprint = "30BB FF3F AB0B BB3E 0435  F83C 8E8F F66E 2AE8 D970";
    }];
  };
  scode = {
    email = "peter.schuller@infidyne.com";
    github = "scode";
    githubId = 59476;
    name = "Peter Schuller";
  };
  scoder12 = {
    name = "Spencer Pogorzelski";
    email = "34356756+Scoder12@users.noreply.github.com";
    github = "Scoder12";
    githubId = 34356756;
  };
  scolobb = {
    email = "sivanov@colimite.fr";
    github = "scolobb";
    githubId = 11320;
    name = "Sergiu Ivanov";
  };
  screendriver = {
    email = "nix@echooff.de";
    github = "screendriver";
    githubId = 149248;
    name = "Christian Rackerseder";
  };
  Scriptkiddi = {
    email = "nixos@scriptkiddi.de";
    matrix = "@fritz.otlinghaus:helsinki-systems.de";
    github = "Scriptkiddi";
    githubId = 3598650;
    name = "Fritz Otlinghaus";
  };
  Scrumplex = {
    name = "Sefa Eyeoglu";
    email = "contact@scrumplex.net";
    matrix = "@Scrumplex:duckhub.io";
    github = "Scrumplex";
    githubId = 11587657;
    keys = [{
      fingerprint = "AF1F B107 E188 CB97 9A94  FD7F C104 1129 4912 A422";
    }];
  };
  scubed2 = {
    email = "scubed2@gmail.com";
    github = "scubed2";
    githubId = 7401858;
    name = "Sterling Stein";
  };
  sdier = {
    email = "scott@dier.name";
    matrix = "@sdier:matrix.org";
    github = "sdier";
    githubId = 11613056;
    name = "Scott Dier";
  };
  SeanZicari = {
    email = "sean.zicari@gmail.com";
    github = "SeanZicari";
    githubId = 2343853;
    name = "Sean Zicari";
  };
  seb314 = {
    email = "sebastian@seb314.com";
    github = "seb314";
    githubId = 19472270;
    name = "Sebastian";
  };
  sebastianblunt = {
    name = "Sebastian Blunt";
    email = "nix@sebastianblunt.com";
    github = "sebastianblunt";
    githubId = 47431204;
  };
  sebbadk = {
    email = "sebastian@sebba.dk";
    github = "SEbbaDK";
    githubId = 1567527;
    name = "Sebastian Hyberts";
  };
  sebbel = {
    email = "hej@sebastian-ball.de";
    github = "sebbel";
    githubId = 1940568;
    name = "Sebastian Ball";
  };
  seberm = {
    email = "seberm@seberm.com";
    github = "seberm";
    githubId = 212597;
    name = "Otto Sabart";
    keys = [{
      fingerprint = "0AF6 4C3B 1F12 14B3 8C8C  5786 1FA2 DBE6 7438 7CC3";
    }];
  };
  sebtm = {
    email = "mail@sebastian-sellmeier.de";
    github = "SebTM";
    githubId = 17243347;
    name = "Sebastian Sellmeier";
  };
  sellout = {
    email = "greg@technomadic.org";
    github = "sellout";
    githubId = 33031;
    name = "Greg Pfeil";
  };
  sengaya = {
    email = "tlo@sengaya.de";
    github = "sengaya";
    githubId = 1286668;
    name = "Thilo Uttendorfer";
  };
  sephalon = {
    email = "me@sephalon.net";
    github = "sephalon";
    githubId = 893474;
    name = "Stefan Wiehler";
  };
  sephi = {
    name = "Sylvain Fankhauser";
    email = "sephi@fhtagn.top";
    github = "sephii";
    githubId = 754333;
    keys = [{
      fingerprint = "2A9D 8E76 5EE2 237D 7B6B  A2A5 4228 AB9E C061 2ADA";
    }];
  };
  sepi = {
    email = "raffael@mancini.lu";
    github = "sepi";
    githubId = 529649;
    name = "Raffael Mancini";
  };
  seppeljordan = {
    email = "sebastian.jordan.mail@googlemail.com";
    github = "seppeljordan";
    githubId = 4805746;
    name = "Sebastian Jordan";
  };
  seqizz = {
    email = "seqizz@gmail.com";
    github = "seqizz";
    githubId = 307899;
    name = "Gurkan Gur";
  };
  serge = {
    email = "sb@canva.com";
    github = "serge-belov";
    githubId = 38824235;
    name = "Serge Belov";
  };
  sersorrel = {
    email = "ash@sorrel.sh";
    github = "sersorrel";
    githubId = 9433472;
    name = "ash";
  };
  servalcatty = {
    email = "servalcat@pm.me";
    github = "servalcatty";
    githubId = 51969817;
    name = "Serval";
    keys = [{
      fingerprint = "A317 37B3 693C 921B 480C  C629 4A2A AAA3 82F8 294C";
    }];
  };
  seylerius = {
    name = "Sable Seyler";
    email = "sable@seyleri.us";
    github = "seylerius";
    githubId = 1145981;
    keys = [{
      fingerprint = "7246 B6E1 ABB9 9A48 4395  FD11 DC26 B921 A9E9 DBDE";
    }];
  };
  sfrijters = {
    email = "sfrijters@gmail.com";
    github = "SFrijters";
    githubId = 918365;
    name = "Stefan Frijters";
  };
  sgo = {
    email = "stig@stig.io";
    github = "stigtsp";
    githubId = 75371;
    name = "Stig Palmquist";
  };
  sgraf = {
    email = "sgraf1337@gmail.com";
    github = "sgraf812";
    githubId = 1151264;
    name = "Sebastian Graf";
  };
  shadaj = {
    email = "shadaj@users.noreply.github.com";
    github = "shadaj";
    githubId = 543055;
    name = "Shadaj Laddad";
  };
  shadowrz = {
    email = "shadowrz+nixpkgs@disroot.org";
    matrix = "@ShadowRZ:matrixim.cc";
    github = "ShadowRZ";
    githubId = 23130178;
    name = "夜坂雅";
  };
  shahrukh330 = {
    email = "shahrukh330@gmail.com";
    github = "shahrukh330";
    githubId = 1588288;
    name = "Shahrukh Khan";
  };
  shamilton = {
    email = "sgn.hamilton@protonmail.com";
    github = "SCOTT-HAMILTON";
    githubId = 24496705;
    name = "Scott Hamilton";
  };
  ShamrockLee = {
    name = "Shamrock Lee";
    email = "44064051+ShamrockLee@users.noreply.github.com";
    github = "ShamrockLee";
    githubId = 44064051;
  };
  shanemikel = {
    email = "shanepearlman@pm.me";
    github = "shanemikel";
    githubId = 6720672;
    name = "Shane Pearlman";
  };
  shanesveller = {
    email = "shane@sveller.dev";
    github = "shanesveller";
    githubId = 831;
    keys = [{
      fingerprint = "F83C 407C ADC4 5A0F 1F2F  44E8 9210 C218 023C 15CD";
    }];
    name = "Shane Sveller";
  };
  shawndellysse = {
    email = "sdellysse@gmail.com";
    github = "sdellysse";
    githubId = 293035;
    name = "Shawn Dellysse";
  };
  shawn8901 = {
    email = "shawn8901@googlemail.com";
    github = "Shawn8901";
    githubId = 12239057;
    name = "Shawn8901";
  };
  shazow = {
    email = "andrey.petrov@shazow.net";
    github = "shazow";
    githubId = 6292;
    name = "Andrey Petrov";
  };
  sheenobu = {
    email = "sheena.artrip@gmail.com";
    github = "sheenobu";
    githubId = 1443459;
    name = "Sheena Artrip";
  };
  sheepforce = {
    email = "phillip.seeber@googlemail.com";
    github = "sheepforce";
    githubId = 16844216;
    name = "Phillip Seeber";
  };
  sheganinans = {
    email = "sheganinans@gmail.com";
    github = "sheganinans";
    githubId = 2146203;
    name = "Aistis Raulinaitis";
  };
  shell = {
    email = "cam.turn@gmail.com";
    github = "VShell";
    githubId = 251028;
    name = "Shell Turner";
  };
  shikanime = {
    name = "William Phetsinorath";
    email = "deva.shikanime@protonmail.com";
    github = "shikanime";
    githubId = 22115108;
  };
  shiryel = {
    email = "contact@shiryel.com";
    name = "Shiryel";
    github = "shiryel";
    githubId = 35617139;
    keys = [{
      fingerprint = "AB63 4CD9 3322 BD42 6231  F764 C404 1EA6 B326 33DE";
    }];
  };
  shlevy = {
    email = "shea@shealevy.com";
    github = "shlevy";
    githubId = 487050;
    name = "Shea Levy";
  };
  shmish111 = {
    email = "shmish111@gmail.com";
    github = "shmish111";
    githubId = 934267;
    name = "David Smith";
  };
  shnarazk = {
    email = "shujinarazaki@protonmail.com";
    github = "shnarazk";
    githubId = 997855;
    name = "Narazaki Shuji";
  };
  shofius = {
    name = "Sam Hofius";
    email = "sam@samhofi.us";
    github = "kf5grd";
    githubId = 18297490;
  };
  shou = {
    email = "x+g@shou.io";
    github = "Shou";
    githubId = 819413;
    name = "Benedict Aas";
  };
  shreerammodi = {
    name = "Shreeram Modi";
    email = "shreerammodi10@gmail.com";
    github = "Shrimpram";
    githubId = 67710369;
    keys = [{
      fingerprint = "EA88 EA07 26E9 6CBF 6365  3966 163B 16EE 76ED 24CE";
    }];
  };
  shyim = {
    email = "s.sayakci@gmail.com";
    github = "shyim";
    githubId = 6224096;
    name = "Soner Sayakci";
  };
  siddharthist = {
    email = "langston.barrett@gmail.com";
    github = "langston-barrett";
    githubId = 4294323;
    name = "Langston Barrett";
  };
  sielicki = {
    name = "Nicholas Sielicki";
    email = "nix@opensource.nslick.com";
    github = "sielicki";
    githubId = 4522995;
    matrix = "@sielicki:matrix.org";
  };
  siers = {
    email = "veinbahs+nixpkgs@gmail.com";
    github = "siers";
    githubId = 235147;
    name = "Raitis Veinbahs";
  };
  sifmelcara = {
    email = "ming@culpring.com";
    github = "sifmelcara";
    githubId = 10496191;
    name = "Ming Chuan";
  };
  sigma = {
    email = "yann.hodique@gmail.com";
    github = "sigma";
    githubId = 16090;
    name = "Yann Hodique";
  };
  sikmir = {
    email = "sikmir@disroot.org";
    github = "sikmir";
    githubId = 688044;
    name = "Nikolay Korotkiy";
    keys = [{
      fingerprint = "ADF4 C13D 0E36 1240 BD01  9B51 D1DE 6D7F 6936 63A5";
    }];
  };
  simarra = {
    name = "simarra";
    email = "loic.martel@protonmail.com";
    github = "Simarra";
    githubId = 14372987;
  };
  simoneruffini = {
    email = "simone.ruffini@tutanota.com";
    github = "simoneruffini";
    githubId = 50401154;
    name = "Simone Ruffini";
  };
  simonchatts = {
    email = "code@chatts.net";
    github = "simonchatts";
    githubId = 11135311;
    name = "Simon Chatterjee";
  };
  simonkampe = {
    email = "simon.kampe+nix@gmail.com";
    github = "simonkampe";
    githubId = 254799;
    name = "Simon Kämpe";
  };
  simonvandel = {
    email = "simon.vandel@gmail.com";
    github = "simonvandel";
    githubId = 2770647;
    name = "Simon Vandel Sillesen";
  };
  sir4ur0n = {
    email = "sir4ur0n@users.noreply.github.com";
    github = "sir4ur0n";
    githubId = 1204125;
    name = "sir4ur0n";
  };
  siraben = {
    email = "bensiraphob@gmail.com";
    matrix = "@siraben:matrix.org";
    github = "siraben";
    githubId = 8219659;
    name = "Siraphob Phipathananunth";
  };
  siriobalmelli = {
    email = "sirio@b-ad.ch";
    github = "siriobalmelli";
    githubId = 23038812;
    name = "Sirio Balmelli";
    keys = [{
      fingerprint = "B234 EFD4 2B42 FE81 EE4D  7627 F72C 4A88 7F9A 24CA";
    }];
  };
  sirseruju = {
    email = "sir.seruju@yandex.ru";
    github = "SirSeruju";
    githubId = 74881555;
    name = "Fofanov Sergey";
  };
  sivteck = {
    email = "sivaram1992@gmail.com";
    github = "sivteck";
    githubId = 8017899;
    name = "Sivaram Balakrishnan";
  };
  sjagoe = {
    email = "simon@simonjagoe.com";
    github = "sjagoe";
    githubId = 80012;
    name = "Simon Jagoe";
  };
  sjau = {
    email = "nixos@sjau.ch";
    github = "sjau";
    githubId = 848812;
    name = "Stephan Jau";
  };
  sjfloat = {
    email = "steve+nixpkgs@jonescape.com";
    github = "sjfloat";
    githubId = 216167;
    name = "Steve Jones";
  };
  sjmackenzie = {
    email = "setori88@gmail.com";
    github = "sjmackenzie";
    githubId = 158321;
    name = "Stewart Mackenzie";
  };
  skeidel = {
    email = "svenkeidel@gmail.com";
    github = "svenkeidel";
    githubId = 266500;
    name = "Sven Keidel";
  };
  skykanin = {
    email = "skykanin@users.noreply.github.com";
    github = "skykanin";
    githubId = 3789764;
    name = "skykanin";
  };
  sleexyz = {
    email = "freshdried@gmail.com";
    github = "sleexyz";
    githubId = 1505617;
    name = "Sean Lee";
  };
  SlothOfAnarchy = {
    email = "slothofanarchy1@gmail.com";
    matrix = "@michel.weitbrecht:helsinki-systems.de";
    github = "SlothOfAnarchy";
    githubId = 12828415;
    name = "Michel Weitbrecht";
  };
  smakarov = {
    email = "setser200018@gmail.com";
    github = "SeTSeR";
    githubId = 12733495;
    name = "Sergey Makarov";
    keys = [{
      fingerprint = "6F8A 18AE 4101 103F 3C54  24B9 6AA2 3A11 93B7 064B";
    }];
  };
  smancill = {
    email = "smancill@smancill.dev";
    github = "smancill";
    githubId = 238528;
    name = "Sebastián Mancilla";
  };
  smaret = {
    email = "sebastien.maret@icloud.com";
    github = "smaret";
    githubId = 95471;
    name = "Sébastien Maret";
    keys = [{
      fingerprint = "4242 834C D401 86EF 8281  4093 86E3 0E5A 0F5F C59C";
    }];
  };
  smasher164 = {
    email = "aindurti@gmail.com";
    github = "smasher164";
    githubId = 12636891;
    name = "Akhil Indurti";
  };
  smironov = {
    email = "grrwlf@gmail.com";
    github = "grwlf";
    githubId = 4477729;
    name = "Sergey Mironov";
  };
  smitop = {
    name = "Smitty van Bodegom";
    email = "me@smitop.com";
    matrix = "@smitop:kde.org";
    github = "Smittyvb";
    githubId = 10530973;
  };
  sna = {
    email = "abouzahra.9@wright.edu";
    github = "S-NA";
    githubId = 20214715;
    name = "S. Nordin Abouzahra";
  };
  snaar = {
    email = "snaar@snaar.net";
    github = "snaar";
    githubId = 602439;
    name = "Serguei Narojnyi";
  };
  snapdgn = {
    email = "snapdgn@proton.me";
    name = "Nitish Kumar";
    github = "snapdgn";
    githubId = 85608760;
  };
  snicket2100 = {
    email = "57048005+snicket2100@users.noreply.github.com";
    github = "snicket2100";
    githubId = 57048005;
    name = "snicket2100";
  };
  snyh = {
    email = "snyh@snyh.org";
    github = "snyh";
    githubId = 1437166;
    name = "Xia Bin";
  };
  softinio = {
    email = "code@softinio.com";
    github = "softinio";
    githubId = 3371635;
    name = "Salar Rahmanian";
  };
  sohalt = {
    email = "nixos@sohalt.net";
    github = "Sohalt";
    githubId = 2157287;
    name = "sohalt";
  };
  solson = {
    email = "scott@solson.me";
    matrix = "@solson:matrix.org";
    github = "solson";
    githubId = 26806;
    name = "Scott Olson";
  };
  somasis = {
    email = "kylie@somas.is";
    github = "somasis";
    githubId = 264788;
    name = "Kylie McClain";
  };
  SomeoneSerge = {
    email = "sergei.kozlukov@aalto.fi";
    matrix = "@ss:someonex.net";
    github = "SomeoneSerge";
    githubId = 9720532;
    name = "Sergei K";
  };
  sophrosyne = {
    email = "joshuaortiz@tutanota.com";
    github = "sophrosyne97";
    githubId = 53029739;
    name = "Joshua Ortiz";
  };
  sorki = {
    email = "srk@48.io";
    github = "sorki";
    githubId = 115308;
    name = "Richard Marko";
  };
  sorpaas = {
    email = "hi@that.world";
    github = "sorpaas";
    githubId = 6277322;
    name = "Wei Tang";
  };
  spacefrogg = {
    email = "spacefrogg-nixos@meterriblecrew.net";
    github = "spacefrogg";
    githubId = 167881;
    name = "Michael Raitza";
  };
  spacekookie = {
    email = "kookie@spacekookie.de";
    github = "spacekookie";
    githubId = 7669898;
    name = "Katharina Fey";
  };
  spease = {
    email = "peasteven@gmail.com";
    github = "spease";
    githubId = 2825204;
    name = "Steven Pease";
  };
  spencerjanssen = {
    email = "spencerjanssen@gmail.com";
    matrix = "@sjanssen:matrix.org";
    github = "spencerjanssen";
    githubId = 2600039;
    name = "Spencer Janssen";
  };
  spinus = {
    email = "tomasz.czyz@gmail.com";
    github = "spinus";
    githubId = 950799;
    name = "Tomasz Czyż";
  };
  sprock = {
    email = "rmason@mun.ca";
    github = "sprock";
    githubId = 6391601;
    name = "Roger Mason";
  };
  spwhitt = {
    email = "sw@swhitt.me";
    github = "spwhitt";
    githubId = 1414088;
    name = "Spencer Whitt";
  };
  squalus = {
    email = "squalus@squalus.net";
    github = "squalus";
    githubId = 36899624;
    name = "squalus";
  };
  squarepear = {
    email = "contact@jeffreyharmon.dev";
    github = "SquarePear";
    githubId = 16364318;
    name = "Jeffrey Harmon";
  };
  srapenne = {
    email = "solene@perso.pw";
    github = "rapenne-s";
    githubId = 248016;
    name = "Solène Rapenne";
  };
  srghma = {
    email = "srghma@gmail.com";
    github = "srghma";
    githubId = 7573215;
    name = "Sergei Khoma";
  };
  srgom = {
    email = "srgom@users.noreply.github.com";
    github = "SRGOM";
    githubId = 8103619;
    name = "SRGOM";
  };
  srhb = {
    email = "sbrofeldt@gmail.com";
    matrix = "@srhb:matrix.org";
    github = "srhb";
    githubId = 219362;
    name = "Sarah Brofeldt";
  };
  SShrike = {
    email = "severen@shrike.me";
    github = "severen";
    githubId = 4061736;
    name = "Severen Redwood";
  };
  sstef = {
    email = "stephane@nix.frozenid.net";
    github = "haskelious";
    githubId = 8668915;
    name = "Stephane Schitter";
  };
  staccato = {
    name = "staccato";
    email = "moveq@riseup.net";
    github = "braaandon";
    githubId = 86573128;
  };
  stackshadow = {
    email = "stackshadow@evilbrain.de";
    github = "stackshadow";
    githubId = 7512804;
    name = "Martin Langlotz";
  };
  stargate01 = {
    email = "christoph.honal@web.de";
    github = "StarGate01";
    githubId = 6362238;
    name = "Christoph Honal";
  };
  stasjok = {
    name = "Stanislav Asunkin";
    email = "nixpkgs@stasjok.ru";
    github = "stasjok";
    githubId = 1353637;
  };
  steamwalker = {
    email = "steamwalker@xs4all.nl";
    github = "steamwalker";
    githubId = 94006354;
    name = "steamwalker";
  };
  steell = {
    email = "steve@steellworks.com";
    github = "Steell";
    githubId = 1699155;
    name = "Steve Elliott";
  };
  stehessel = {
    email = "stephan@stehessel.de";
    github = "stehessel";
    githubId = 55607356;
    name = "Stephan Heßelmann";
  };
  steinybot = {
    name = "Jason Pickens";
    email = "jasonpickensnz@gmail.com";
    matrix = "@steinybot:matrix.org";
    github = "steinybot";
    githubId = 4659562;
    keys = [{
      fingerprint = "2709 1DEC CC42 4635 4299  569C 21DE 1CAE 5976 2A0F";
    }];
  };
  stelcodes = {
    email = "stel@stel.codes";
    github = "stelcodes";
    githubId = 22163194;
    name = "Stel Abrego";
  };
  stephank = {
    email = "nix@stephank.nl";
    matrix = "@skochen:matrix.org";
    github = "stephank";
    githubId = 89950;
    name = "Stéphan Kochen";
  };
  stephenmw = {
    email = "stephen@q5comm.com";
    github = "stephenmw";
    githubId = 231788;
    name = "Stephen Weinberg";
  };
  stephenwithph = {
    name = "StephenWithPH";
    email = "StephenWithPH@users.noreply.github.com";
    github = "StephenWithPH";
    githubId = 2990492;
  };
  sterfield = {
    email = "sterfield@gmail.com";
    github = "sterfield";
    githubId = 5747061;
    name = "Guillaume Loetscher";
  };
  sternenseemann = {
    email = "sternenseemann@systemli.org";
    github = "sternenseemann";
    githubId = 3154475;
    name = "Lukas Epple";
  };
  steshaw = {
    name = "Steven Shaw";
    email = "steven@steshaw.org";
    github = "steshaw";
    githubId = 45735;
    keys = [{
      fingerprint = "0AFE 77F7 474D 1596 EE55  7A29 1D9A 17DF D23D CB91";
    }];
  };
  stesie = {
    email = "stesie@brokenpipe.de";
    github = "stesie";
    githubId = 113068;
    name = "Stefan Siegl";
  };
  steve-chavez = {
    email = "stevechavezast@gmail.com";
    github = "steve-chavez";
    githubId = 1829294;
    name = "Steve Chávez";
  };
  stevebob = {
    email = "stephen@sherra.tt";
    github = "gridbugs";
    githubId = 417118;
    name = "Stephen Sherratt";
  };
  steveej = {
    email = "mail@stefanjunker.de";
    github = "steveeJ";
    githubId = 1181362;
    name = "Stefan Junker";
  };
  stevenroose = {
    email = "github@stevenroose.org";
    github = "stevenroose";
    githubId = 853468;
    name = "Steven Roose";
  };
  stianlagstad = {
    email = "stianlagstad@gmail.com";
    github = "stianlagstad";
    githubId = 4340859;
    name = "Stian Lågstad";
  };
  StijnDW = {
    email = "nixdev@rinsa.eu";
    github = "Stekke";
    githubId = 1751956;
    name = "Stijn DW";
  };
  StillerHarpo = {
    email = "florianengel39@gmail.com";
    github = "StillerHarpo";
    githubId = 25526706;
    name = "Florian Engel";
  };
  stites = {
    email = "sam@stites.io";
    github = "stites";
    githubId = 1694705;
    name = "Sam Stites";
  };
  strager = {
    email = "strager.nds@gmail.com";
    github = "strager";
    githubId = 48666;
    name = "Matthew \"strager\" Glazar";
  };
  strikerlulu = {
    email = "strikerlulu7@gmail.com";
    github = "strikerlulu";
    githubId = 38893265;
    name = "StrikerLulu";
  };
  stumoss = {
    email = "samoss@gmail.com";
    github = "stumoss";
    githubId = 638763;
    name = "Stuart Moss";
  };
  stunkymonkey = {
    email = "account@buehler.rocks";
    github = "Stunkymonkey";
    githubId = 1315818;
    name = "Felix Bühler";
  };
  stupremee = {
    email = "jutus.k@protonmail.com";
    github = "Stupremee";
    githubId = 39732259;
    name = "Justus K";
  };
  SubhrajyotiSen = {
    email = "subhrajyoti12@gmail.com";
    github = "SubhrajyotiSen";
    githubId = 12984845;
    name = "Subhrajyoti Sen";
  };
  sudosubin = {
    email = "sudosubin@gmail.com";
    github = "sudosubin";
    githubId = 32478597;
    name = "Subin Kim";
  };
  suhr = {
    email = "suhr@i2pmail.org";
    github = "suhr";
    githubId = 65870;
    name = "Сухарик";
  };
  sumnerevans = {
    email = "me@sumnerevans.com";
    github = "sumnerevans";
    githubId = 16734772;
    name = "Sumner Evans";
  };
  suominen = {
    email = "kimmo@suominen.com";
    github = "suominen";
    githubId = 1939855;
    name = "Kimmo Suominen";
  };
  superbo = {
    email = "supernbo@gmail.com";
    github = "SuperBo";
    githubId = 2666479;
    name = "Y Nguyen";
  };
  SuperSandro2000 = {
    email = "sandro.jaeckel@gmail.com";
    matrix = "@sandro:supersandro.de";
    github = "SuperSandro2000";
    githubId = 7258858;
    name = "Sandro Jäckel";
  };
  SuprDewd = {
    email = "suprdewd@gmail.com";
    github = "SuprDewd";
    githubId = 187109;
    name = "Bjarki Ágúst Guðmundsson";
  };
  suryasr007 = {
    email = "94suryateja@gmail.com";
    github = "suryasr007";
    githubId = 10533926;
    name = "Surya Teja V";
  };
  suvash = {
    email = "suvash+nixpkgs@gmail.com";
    github = "suvash";
    githubId = 144952;
    name = "Suvash Thapaliya";
  };
  sveitser = {
    email = "sveitser@gmail.com";
    github = "sveitser";
    githubId = 1040871;
    name = "Mathis Antony";
  };
  sven-of-cord = {
    email = "sven@cord.com";
    github = "sven-of-cord";
    githubId = 98333944;
    name = "Sven Over";
  };
  svend = {
    email = "svend@svends.net";
    github = "svend";
    githubId = 306190;
    name = "Svend Sorensen";
  };
  svrana = {
    email = "shaw@vranix.com";
    github = "svrana";
    githubId = 850665;
    name = "Shaw Vrana";
  };
  svsdep = {
    email = "svsdep@gmail.com";
    github = "svsdep";
    githubId = 36695359;
    name = "Vasyl Solovei";
  };
  swarren83 = {
    email = "shawn.w.warren@gmail.com";
    github = "swarren83";
    githubId = 4572854;
    name = "Shawn Warren";
  };
  swdunlop = {
    email = "swdunlop@gmail.com";
    github = "swdunlop";
    githubId = 120188;
    name = "Scott W. Dunlop";
  };
  sweber = {
    email = "sweber2342+nixpkgs@gmail.com";
    github = "sweber83";
    githubId = 19905904;
    name = "Simon Weber";
  };
  sweenu = {
    name = "sweenu";
    email = "contact@sweenu.xyz";
    github = "sweenu";
    githubId = 7051978;
  };
  swflint = {
    email = "swflint@flintfam.org";
    github = "swflint";
    githubId = 1771109;
    name = "Samuel W. Flint";
  };
  swistak35 = {
    email = "me@swistak35.com";
    github = "swistak35";
    githubId = 332289;
    name = "Rafał Łasocha";
  };
  syberant = {
    email = "sybrand@neuralcoding.com";
    github = "syberant";
    githubId = 20063502;
    name = "Sybrand Aarnoutse";
  };
  symphorien = {
    email = "symphorien_nixpkgs@xlumurb.eu";
    matrix = "@symphorien:xlumurb.eu";
    github = "symphorien";
    githubId = 12595971;
    name = "Guillaume Girol";
  };
  synthetica = {
    email = "nix@hilhorst.be";
    github = "Synthetica9";
    githubId = 7075751;
    name = "Patrick Hilhorst";
  };
  szczyp = {
    email = "qb@szczyp.com";
    github = "Szczyp";
    githubId = 203195;
    name = "Szczyp";
  };
  szlend = {
    email = "pub.nix@zlender.si";
    github = "szlend";
    githubId = 7301807;
    name = "Simon Žlender";
  };
  sztupi = {
    email = "attila.sztupak@gmail.com";
    github = "sztupi";
    githubId = 143103;
    name = "Attila Sztupak";
  };
  t184256 = {
    email = "monk@unboiled.info";
    github = "t184256";
    githubId = 5991987;
    name = "Alexander Sosedkin";
  };
  tadeokondrak = {
    email = "me@tadeo.ca";
    github = "tadeokondrak";
    githubId = 4098453;
    name = "Tadeo Kondrak";
    keys = [{
      fingerprint = "0F2B C0C7 E77C 5B42 AC5B  4C18 FBE6 07FC C495 16D3";
    }];
  };
  tadfisher = {
    email = "tadfisher@gmail.com";
    github = "tadfisher";
    githubId = 129148;
    name = "Tad Fisher";
  };
  taeer = {
    email = "taeer@necsi.edu";
    github = "Radvendii";
    githubId = 1239929;
    name = "Taeer Bar-Yam";
  };
  taha = {
    email = "xrcrod@gmail.com";
    github = "tgharib";
    githubId = 6457015;
    name = "Taha Gharib";
  };
  tailhook = {
    email = "paul@colomiets.name";
    github = "tailhook";
    githubId = 321799;
    name = "Paul Colomiets";
  };
  taikx4 = {
    email = "taikx4@taikx4szlaj2rsdupcwabg35inbny4jk322ngeb7qwbbhd5i55nf5yyd.onion";
    github = "taikx4";
    githubId = 94917129;
    name = "taikx4";
    keys = [{
      fingerprint = "6B02 8103 C4E5 F68C D77C  9E54 CCD5 2C7B 37BB 837E";
    }];
  };
  takagiy = {
    email = "takagiy.4dev@gmail.com";
    github = "takagiy";
    githubId = 18656090;
    name = "Yuki Takagi";
  };
  taketwo = {
    email = "alexandrov88@gmail.com";
    github = "taketwo";
    githubId = 1241736;
    name = "Sergey Alexandrov";
  };
  takikawa = {
    email = "asumu@igalia.com";
    github = "takikawa";
    githubId = 64192;
    name = "Asumu Takikawa";
  };
  taktoa = {
    email = "taktoa@gmail.com";
    matrix = "@taktoa:matrix.org";
    github = "taktoa";
    githubId = 553443;
    name = "Remy Goldschmidt";
  };
  taku0 = {
    email = "mxxouy6x3m_github@tatapa.org";
    github = "taku0";
    githubId = 870673;
    name = "Takuo Yonezawa";
  };
  talkara = {
    email = "taito.horiuchi@relexsolutions.com";
    github = "talkara";
    githubId = 51232929;
    name = "Taito Horiuchi";
  };
  talyz = {
    email = "kim.lindberger@gmail.com";
    matrix = "@talyz:matrix.org";
    github = "talyz";
    githubId = 63433;
    name = "Kim Lindberger";
  };
  taneb = {
    email = "nvd1234@gmail.com";
    github = "Taneb";
    githubId = 1901799;
    name = "Nathan van Doorn";
  };
  tari = {
    email = "peter@taricorp.net";
    github = "tari";
    githubId = 506181;
    name = "Peter Marheine";
  };
  tasmo = {
    email = "tasmo@tasmo.de";
    github = "tasmo";
    githubId = 102685;
    name = "Thomas Friese";
  };
  taylor1791 = {
    email = "nixpkgs@tayloreverding.com";
    github = "taylor1791";
    githubId = 555003;
    name = "Taylor Everding";
  };
  tazjin = {
    email = "mail@tazj.in";
    github = "tazjin";
    githubId = 1552853;
    name = "Vincent Ambo";
  };
  tbenst = {
    email = "nix@tylerbenster.com";
    github = "tbenst";
    githubId = 863327;
    name = "Tyler Benster";
  };
  tboerger = {
    email = "thomas@webhippie.de";
    matrix = "@tboerger:matrix.org";
    github = "tboerger";
    githubId = 156964;
    name = "Thomas Boerger";
  };
  tcbravo = {
    email = "tomas.bravo@protonmail.ch";
    github = "tcbravo";
    githubId = 66133083;
    name = "Tomas Bravo";
  };
  tchab = {
    email = "dev@chabs.name";
    github = "t-chab";
    githubId = 2120966;
    name = "t-chab";
  };
  tchekda = {
    email = "contact@tchekda.fr";
    github = "Tchekda";
    githubId = 23559888;
    keys = [{
      fingerprint = "44CE A8DD 3B31 49CD 6246  9D8F D0A0 07ED A4EA DA0F";
    }];
    name = "David Tchekachev";
  };
  tckmn = {
    email = "andy@tck.mn";
    github = "tckmn";
    githubId = 2389333;
    name = "Andy Tockman";
  };
  techknowlogick = {
    email = "techknowlogick@gitea.io";
    github = "techknowlogick";
    githubId = 164197;
    name = "techknowlogick";
  };
  Technical27 = {
    email = "38222826+Technical27@users.noreply.github.com";
    github = "Technical27";
    githubId = 38222826;
    name = "Aamaruvi Yogamani";
  };
  teh = {
    email = "tehunger@gmail.com";
    github = "teh";
    githubId = 139251;
    name = "Tom Hunger";
  };
  tejasag = {
    name = "Tejas Agarwal";
    email = "tejasagarwalbly@gmail.com";
    github = "tejasag";
    githubId = 67542663;
  };
  tejing = {
    name = "Jeff Huffman";
    email = "tejing@tejing.com";
    matrix = "@tejing:matrix.org";
    github = "tejing1";
    githubId = 5663576;
    keys = [{ fingerprint = "6F0F D43B 80E5 583E 60FC  51DC 4936 D067 EB12 AB32"; }];
  };
  telotortium = {
    email = "rirelan@gmail.com";
    github = "telotortium";
    githubId = 1755789;
    name = "Robert Irelan";
  };
  teozkr = {
    email = "teo@nullable.se";
    github = "teozkr";
    githubId = 649832;
    name = "Teo Klestrup Röijezon";
  };
  terin = {
    email = "terinjokes@gmail.com";
    github = "terinjokes";
    githubId = 273509;
    name = "Terin Stock";
  };
  terlar = {
    email = "terlar@gmail.com";
    github = "terlar";
    githubId = 280235;
    name = "Terje Larsen";
  };
  terrorjack = {
    email = "astrohavoc@gmail.com";
    github = "TerrorJack";
    githubId = 3889585;
    name = "Cheng Shao";
  };
  tesq0 = {
    email = "mikolaj.galkowski@gmail.com";
    github = "tesq0";
    githubId = 26417242;
    name = "Mikolaj Galkowski";
  };
  TethysSvensson = {
    email = "freaken@freaken.dk";
    github = "TethysSvensson";
    githubId = 4294434;
    name = "Tethys Svensson";
  };
  teto = {
    email = "mcoudron@hotmail.com";
    github = "teto";
    githubId = 886074;
    name = "Matthieu Coudron";
  };
  teutat3s = {
    email = "teutates@mailbox.org";
    matrix = "@teutat3s:pub.solar";
    github = "teutat3s";
    githubId = 10206665;
    name = "teutat3s";
    keys = [{
      fingerprint = "81A1 1C61 F413 8C84 9139  A4FA 18DA E600 A6BB E705";
    }];
  };
  tex = {
    email = "milan.svoboda@centrum.cz";
    github = "tex";
    githubId = 27386;
    name = "Milan Svoboda";
  };
  tfc = {
    email = "jacek@galowicz.de";
    matrix = "@jonge:ukvly.org";
    github = "tfc";
    githubId = 29044;
    name = "Jacek Galowicz";
  };
  tg-x = {
    email = "*@tg-x.net";
    github = "tg-x";
    githubId = 378734;
    name = "TG ⊗ Θ";
  };
  tgunnoe = {
    email = "t@gvno.net";
    github = "tgunnoe";
    githubId = 7254833;
    name = "Taylor Gunnoe";
  };
  th0rgal = {
    email = "thomas.marchand@tuta.io";
    github = "Th0rgal";
    githubId = 41830259;
    name = "Thomas Marchand";
  };
  thall = {
    email = "niclas.thall@gmail.com";
    github = "thall";
    githubId = 102452;
    name = "Niclas Thall";
  };
  thammers = {
    email = "jawr@gmx.de";
    github = "tobias-hammerschmidt";
    githubId = 2543259;
    name = "Tobias Hammerschmidt";
  };
  thanegill = {
    email = "me@thanegill.com";
    github = "thanegill";
    githubId = 1141680;
    name = "Thane Gill";
  };
  thblt = {
    name = "Thibault Polge";
    email = "thibault@thb.lt";
    matrix = "@thbltp:matrix.org";
    github = "thblt";
    githubId = 2453136;
    keys = [{
      fingerprint = "D2A2 F0A1 E7A8 5E6F B711  DEE5 63A4 4817 A52E AB7B";
    }];
  };
  TheBrainScrambler = {
    email = "esthromeris@riseup.net";
    github = "TheBrainScrambler";
    githubId = 34945377;
    name = "John Smith";
  };
  thedavidmeister = {
    email = "thedavidmeister@gmail.com";
    github = "thedavidmeister";
    githubId = 629710;
    name = "David Meister";
  };
  thefloweringash = {
    email = "lorne@cons.org.nz";
    github = "thefloweringash";
    githubId = 42933;
    name = "Andrew Childs";
  };
  thefenriswolf = {
    email = "stefan.rohrbacher97@gmail.com";
    github = "thefenriswolf";
    githubId = 8547242;
    name = "Stefan Rohrbacher";
  };
  thehedgeh0g = {
    name = "The Hedgehog";
    email = "hedgehog@mrhedgehog.xyz";
    matrix = "@mrhedgehog:jupiterbroadcasting.com";
    github = "theHedgehog0";
    githubId = 35778371;
    keys = [{
      fingerprint = "38A0 29B0 4A7E 4C13 A4BB  86C8 7D51 0786 6B1C 6752";
    }];
  };
  thelegy = {
    email = "mail+nixos@0jb.de";
    github = "thelegy";
    githubId = 3105057;
    name = "Jan Beinke";
  };
  thenonameguy = {
    email = "thenonameguy24@gmail.com";
    name = "Krisztian Szabo";
    github = "thenonameguy";
    githubId = 2217181;
  };
  therealansh = {
    email = "tyagiansh23@gmail.com";
    github = "therealansh";
    githubId = 57180880;
    name = "Ansh Tyagi";
  };
  therishidesai = {
    email = "desai.rishi1@gmail.com";
    github = "therishidesai";
    githubId = 5409166;
    name = "Rishi Desai";
  };
  thesola10 = {
    email = "me@thesola.io";
    github = "Thesola10";
    githubId = 7287268;
    keys = [{
      fingerprint = "1D05 13A6 1AC4 0D8D C6D6  5F2C 8924 5619 BEBB 95BA";
    }];
    name = "Karim Vergnes";
  };
  thetallestjj = {
    email = "me+nixpkgs@jeroen-jetten.com";
    github = "TheTallestJJ";
    githubId = 6579555;
    name = "Jeroen Jetten";
  };
  theuni = {
    email = "ct@flyingcircus.io";
    github = "ctheune";
    githubId = 1220572;
    name = "Christian Theune";
  };
  thiagokokada = {
    email = "thiagokokada@gmail.com";
    github = "thiagokokada";
    githubId = 844343;
    name = "Thiago K. Okada";
    matrix = "@k0kada:matrix.org";
  };
  thibaultlemaire = {
    email = "thibault.lemaire@protonmail.com";
    github = "ThibaultLemaire";
    githubId = 21345269;
    name = "Thibault Lemaire";
  };
  thibautmarty = {
    email = "github@thibautmarty.fr";
    matrix = "@thibaut:thibautmarty.fr";
    github = "ThibautMarty";
    githubId = 3268082;
    name = "Thibaut Marty";
  };
  thyol = {
    name = "thyol";
    email = "thyol@pm.me";
    github = "thyol";
    githubId = 81481634;
  };
  thmzlt = {
    email = "git@thomazleite.com";
    github = "thmzlt";
    githubId = 7709;
    name = "Thomaz Leite";
  };
  thomasdesr = {
    email = "git@hive.pw";
    github = "thomasdesr";
    githubId = 681004;
    name = "Thomas Desrosiers";
  };
  ThomasMader = {
    email = "thomas.mader@gmail.com";
    github = "ThomasMader";
    githubId = 678511;
    name = "Thomas Mader";
  };
  thomasjm = {
    email = "tom@codedown.io";
    github = "thomasjm";
    githubId = 1634990;
    name = "Tom McLaughlin";
  };
  thoughtpolice = {
    email = "aseipp@pobox.com";
    github = "thoughtpolice";
    githubId = 3416;
    name = "Austin Seipp";
  };
  thpham = {
    email = "thomas.pham@ithings.ch";
    github = "thpham";
    githubId = 224674;
    name = "Thomas Pham";
  };
  Thra11 = {
    email = "tahall256@protonmail.ch";
    github = "Thra11";
    githubId = 1391883;
    name = "Tom Hall";
  };
  Thunderbottom = {
    email = "chinmaydpai@gmail.com";
    github = "Thunderbottom";
    githubId = 11243138;
    name = "Chinmay D. Pai";
    keys = [{
      fingerprint = "7F3E EEAA EE66 93CC 8782  042A 7550 7BE2 56F4 0CED";
    }];
  };
  tiagolobocastro = {
    email = "tiagolobocastro@gmail.com";
    github = "tiagolobocastro";
    githubId = 1618946;
    name = "Tiago Castro";
  };
  tilcreator = {
    name = "TilCreator";
    email = "contact.nixos@tc-j.de";
    matrix = "@tilcreator:matrix.org";
    github = "TilCreator";
    githubId = 18621411;
  };
  tilpner = {
    email = "till@hoeppner.ws";
    github = "tilpner";
    githubId = 4322055;
    name = "Till Höppner";
  };
  timbertson = {
    email = "tim@gfxmonk.net";
    github = "timbertson";
    githubId = 14172;
    name = "Tim Cuthbertson";
  };
  timma = {
    email = "kunduru.it.iitb@gmail.com";
    github = "ktrsoft";
    githubId = 12712927;
    name = "Timma";
  };
  timokau = {
    email = "timokau@zoho.com";
    github = "timokau";
    githubId = 3799330;
    name = "Timo Kaufmann";
  };
  timor = {
    email = "timor.dd@googlemail.com";
    github = "timor";
    githubId = 174156;
    name = "timor";
  };
  timput = {
    email = "tim@timput.com";
    github = "TimPut";
    githubId = 2845239;
    name = "Tim Put";
  };
  timstott = {
    email = "stott.timothy@gmail.com";
    github = "timstott";
    githubId = 1334474;
    name = "Timothy Stott";
  };
  tiramiseb = {
    email = "sebastien@maccagnoni.eu";
    github = "tiramiseb";
    githubId = 1292007;
    name = "Sébastien Maccagnoni";
  };
  tirex = {
    email = "szymon@kliniewski.pl";
    name = "Szymon Kliniewski";
    github = "NoneTirex";
    githubId = 26038207;
  };
  titanous = {
    email = "jonathan@titanous.com";
    github = "titanous";
    githubId = 13026;
    name = "Jonathan Rudenberg";
  };
  tkerber = {
    email = "tk@drwx.org";
    github = "tkerber";
    githubId = 5722198;
    name = "Thomas Kerber";
    keys = [{
      fingerprint = "556A 403F B0A2 D423 F656  3424 8489 B911 F9ED 617B";
    }];
  };
  tljuniper = {
    email = "tljuniper1@gmail.com";
    github = "tljuniper";
    githubId = 48209000;
    name = "Anna Gillert";
  };
  tmarkovski = {
    email = "tmarkovski@gmail.com";
    github = "tmarkovski";
    githubId = 1280118;
    name = "Tomislav Markovski";
  };
  tmountain = {
    email = "tinymountain@gmail.com";
    github = "tmountain";
    githubId = 135297;
    name = "Travis Whitton";
  };
  tmplt = {
    email = "tmplt@dragons.rocks";
    github = "tmplt";
    githubId = 6118602;
    name = "Viktor";
  };
  tnias = {
    email = "phil@grmr.de";
    matrix = "@tnias:stratum0.org";
    github = "tnias";
    githubId = 9853194;
    name = "Philipp Bartsch";
  };
  toastal = {
    email = "toastal+nix@posteo.net";
    matrix = "@toastal:matrix.org";
    github = "toastal";
    githubId = 561087;
    name = "toastal";
    keys = [{
      fingerprint = "7944 74B7 D236 DAB9 C9EF  E7F9 5CCE 6F14 66D4 7C9E";
    }];
  };
  tobim = {
    email = "nix@tobim.fastmail.fm";
    github = "tobim";
    githubId = 858790;
    name = "Tobias Mayer";
  };
  tobiasBora = {
    email = "tobias.bora.list@gmail.com";
    github = "tobiasBora";
    githubId = 2164118;
    name = "Tobias Bora";
  };
  tokudan = {
    email = "git@danielfrank.net";
    github = "tokudan";
    githubId = 692610;
    name = "Daniel Frank";
  };
  tomahna = {
    email = "kevin.rauscher@tomahna.fr";
    github = "Tomahna";
    githubId = 8577941;
    name = "Kevin Rauscher";
  };
  tomberek = {
    email = "tomberek@gmail.com";
    matrix = "@tomberek:matrix.org";
    github = "tomberek";
    githubId = 178444;
    name = "Thomas Bereknyei";
  };
  tomfitzhenry = {
    email = "tom@tom-fitzhenry.me.uk";
    github = "tomfitzhenry";
    githubId = 61303;
    name = "Tom Fitzhenry";
  };
  tomhoule = {
    email = "secondary+nixpkgs@tomhoule.com";
    github = "tomhoule";
    githubId = 13155277;
    name = "Tom Houle";
  };
  tomodachi94 = {
    email = "tomodachi94+nixpkgs@protonmail.com";
    matrix = "@tomodachi94:matrix.org";
    github = "tomodachi94";
    githubId = 68489118;
    name = "Tomodachi94";
  };
  tomsmeets = {
    email = "tom.tsmeets@gmail.com";
    github = "TomSmeets";
    githubId = 6740669;
    name = "Tom Smeets";
  };
  tomsiewert = {
    email = "tom@siewert.io";
    matrix = "@tom:frickel.earth";
    github = "tomsiewert";
    githubId = 8794235;
    name = "Tom Siewert";
  };
  tonyshkurenko = {
    email = "support@twingate.com";
    github = "tonyshkurenko";
    githubId = 8597964;
    name = "Anton Shkurenko";
  };
  toonn = {
    email = "nixpkgs@toonn.io";
    matrix = "@toonn:matrix.org";
    github = "toonn";
    githubId = 1486805;
    name = "Toon Nolten";
  };
  toschmidt = {
    email = "tobias.schmidt@in.tum.de";
    github = "toschmidt";
    githubId = 27586264;
    name = "Tobias Schmidt";
  };
  totoroot = {
    name = "Matthias Thym";
    email = "git@thym.at";
    github = "totoroot";
    githubId = 39650930;
  };
  ToxicFrog = {
    email = "toxicfrog@ancilla.ca";
    github = "ToxicFrog";
    githubId = 90456;
    name = "Rebecca (Bex) Kelly";
  };
  tpw_rules = {
    name = "Thomas Watson";
    email = "twatson52@icloud.com";
    matrix = "@tpw_rules:matrix.org";
    github = "tpwrules";
    githubId = 208010;
  };
  travisbhartwell = {
    email = "nafai@travishartwell.net";
    github = "travisbhartwell";
    githubId = 10110;
    name = "Travis B. Hartwell";
  };
  travisdavis-ops = {
    email = "travisdavismedia@gmail.com";
    github = "TravisDavis-ops";
    githubId = 52011418;
    name = "Travis Davis";
  };
  traxys = {
    email = "quentin+dev@familleboyer.net";
    github = "traxys";
    githubId = 5623227;
    name = "Quentin Boyer";
  };
  TredwellGit = {
    email = "tredwell@tutanota.com";
    github = "TredwellGit";
    githubId = 61860346;
    name = "Tredwell";
  };
  treemo = {
    email = "matthieu.chevrier@treemo.fr";
    github = "treemo";
    githubId = 207457;
    name = "Matthieu Chevrier";
  };
  trepetti = {
    email = "trepetti@cs.columbia.edu";
    github = "trepetti";
    githubId = 25440339;
    name = "Tom Repetti";
  };
  trevorj = {
    email = "nix@trevor.joynson.io";
    github = "akatrevorjay";
    githubId = 1312290;
    name = "Trevor Joynson";
  };
  tricktron = {
    email = "tgagnaux@gmail.com";
    github = "tricktron";
    githubId = 16036882;
    name = "Thibault Gagnaux";
  };
  trino = {
    email = "muehlhans.hubert@ekodia.de";
    github = "hmuehlhans";
    githubId = 9870613;
    name = "Hubert Mühlhans";
  };
  trobert = {
    email = "thibaut.robert@gmail.com";
    github = "trobert";
    githubId = 504580;
    name = "Thibaut Robert";
  };
  troydm = {
    email = "d.geurkov@gmail.com";
    github = "troydm";
    githubId = 483735;
    name = "Dmitry Geurkov";
  };
  truh = {
    email = "jakob-nixos@truh.in";
    github = "truh";
    githubId = 1183303;
    name = "Jakob Klepp";
  };
  trundle = {
    name = "Andreas Stührk";
    email = "andy@hammerhartes.de";
    github = "Trundle";
    githubId = 332418;
  };
  tscholak = {
    email = "torsten.scholak@googlemail.com";
    github = "tscholak";
    githubId = 1568873;
    name = "Torsten Scholak";
  };
  tshaynik = {
    email = "tshaynik@protonmail.com";
    github = "tshaynik";
    githubId = 15064765;
    name = "tshaynik";
  };
  ttuegel = {
    email = "ttuegel@mailbox.org";
    github = "ttuegel";
    githubId = 563054;
    name = "Thomas Tuegel";
  };
  turion = {
    email = "programming@manuelbaerenz.de";
    github = "turion";
    githubId = 303489;
    name = "Manuel Bärenz";
  };
  tu-maurice = {
    email = "valentin.gehrke+nixpkgs@zom.bi";
    github = "tu-maurice";
    githubId = 16151097;
    name = "Valentin Gehrke";
  };
  tuxinaut = {
    email = "trash4you@tuxinaut.de";
    github = "tuxinaut";
    githubId = 722482;
    name = "Denny Schäfer";
    keys = [{
      fingerprint = "C752 0E49 4D92 1740 D263  C467 B057 455D 1E56 7270";
    }];
  };
  tv = {
    email = "tv@krebsco.de";
    github = "4z3";
    githubId = 427872;
    name = "Tomislav Viljetić";
  };
  tvestelind = {
    email = "tomas.vestelind@fripost.org";
    github = "tvestelind";
    githubId = 699403;
    name = "Tomas Vestelind";
  };
  tviti = {
    email = "tviti@hawaii.edu";
    github = "tviti";
    githubId = 2251912;
    name = "Taylor Viti";
  };
  tvorog = {
    email = "marszaripov@gmail.com";
    github = "TvoroG";
    githubId = 1325161;
    name = "Marsel Zaripov";
  };
  tweber = {
    email = "tw+nixpkgs@360vier.de";
    github = "thorstenweber83";
    githubId = 9413924;
    name = "Thorsten Weber";
  };
  twey = {
    email = "twey@twey.co.uk";
    github = "Twey";
    githubId = 101639;
    name = "James ‘Twey’ Kay";
  };
  twhitehead = {
    name = "Tyson Whitehead";
    email = "twhitehead@gmail.com";
    github = "twhitehead";
    githubId = 787843;
    keys = [{
      fingerprint = "E631 8869 586F 99B4 F6E6  D785 5942 58F0 389D 2802";
    }];
  };
  twitchyliquid64 = {
    name = "Tom";
    email = "twitchyliquid64@ciphersink.net";
    github = "twitchyliquid64";
    githubId = 6328589;
  };
  tylerjl = {
    email = "tyler+nixpkgs@langlois.to";
    github = "tylerjl";
    githubId = 1733846;
    matrix = "@ty:tjll.net";
    name = "Tyler Langlois";
  };
  typetetris = {
    email = "ericwolf42@mail.com";
    github = "typetetris";
    githubId = 1983821;
    name = "Eric Wolf";
  };
  uakci = {
    name = "uakci";
    email = "uakci@uakci.pl";
    github = "uakci";
    githubId = 6961268;
  };
  udono = {
    email = "udono@virtual-things.biz";
    github = "udono";
    githubId = 347983;
    name = "Udo Spallek";
  };
  ulrikstrid = {
    email = "ulrik.strid@outlook.com";
    github = "ulrikstrid";
    githubId = 1607770;
    name = "Ulrik Strid";
  };
  unclechu = {
    name = "Viacheslav Lotsmanov";
    email = "lotsmanov89@gmail.com";
    github = "unclechu";
    githubId = 799353;
    keys = [{
      fingerprint = "EE59 5E29 BB5B F2B3 5ED2  3F1C D276 FF74 6700 7335";
    }];
  };
  unhammer = {
    email = "unhammer@fsfe.org";
    github = "unhammer";
    githubId = 56868;
    name = "Kevin Brubeck Unhammer";
    keys = [{
      fingerprint = "50D4 8796 0B86 3F05 4B6A  12F9 7426 06DE 766A C60C";
    }];
  };
  uniquepointer = {
    email = "uniquepointer@mailbox.org";
    matrix = "@uniquepointer:matrix.org";
    github = "uniquepointer";
    githubId = 71751817;
    name = "uniquepointer";
  };
  unode = {
    email = "alves.rjc@gmail.com";
    matrix = "@renato_alves:matrix.org";
    github = "unode";
    githubId = 122319;
    name = "Renato Alves";
  };
  unrooted = {
    name = "Konrad Klawikowski";
    email = "konrad.root.klawikowski@gmail.com";
    github = "unrooted";
    githubId = 30440603;
  };
  uralbash = {
    email = "root@uralbash.ru";
    github = "uralbash";
    githubId = 619015;
    name = "Svintsov Dmitry";
  };
  urandom = {
    email = "colin@urandom.co.uk";
    matrix = "@urandom0:matrix.org";
    github = "urandom2";
    githubId = 2526260;
    keys = [{
      fingerprint = "04A3 A2C6 0042 784A AEA7  D051 0447 A663 F7F3 E236";
    }];
    name = "Colin Arnott";
  };
  urbas = {
    email = "matej.urbas@gmail.com";
    github = "urbas";
    githubId = 771193;
    name = "Matej Urbas";
  };
  uri-canva = {
    email = "uri@canva.com";
    github = "uri-canva";
    githubId = 33242106;
    name = "Uri Baghin";
  };
  urlordjames = {
    email = "urlordjames@gmail.com";
    github = "urlordjames";
    githubId = 32751441;
    name = "urlordjames";
  };
  ursi = {
    email = "masondeanm@aol.com";
    github = "ursi";
    githubId = 17836748;
    name = "Mason Mackaman";
  };
  uskudnik = {
    email = "urban.skudnik@gmail.com";
    github = "uskudnik";
    githubId = 120451;
    name = "Urban Skudnik";
  };
  usrfriendly = {
    name = "Arin Lares";
    email = "arinlares@gmail.com";
    github = "usrfriendly";
    githubId = 2502060;
  };
  utdemir = {
    email = "me@utdemir.com";
    github = "utdemir";
    githubId = 928084;
    name = "Utku Demir";
  };
  uthar = {
    email = "galkowskikasper@gmail.com";
    github = "uthar";
    githubId = 15697697;
    name = "Kasper Gałkowski";
  };
  uvnikita = {
    email = "uv.nikita@gmail.com";
    github = "uvNikita";
    githubId = 1084748;
    name = "Nikita Uvarov";
  };
  uwap = {
    email = "me@uwap.name";
    github = "uwap";
    githubId = 2212422;
    name = "uwap";
  };
  V = {
    name = "V";
    email = "v@anomalous.eu";
    github = "deviant";
    githubId = 68829907;
  };
  vaibhavsagar = {
    email = "vaibhavsagar@gmail.com";
    matrix = "@vaibhavsagar:matrix.org";
    github = "vaibhavsagar";
    githubId = 1525767;
    name = "Vaibhav Sagar";
  };
  valebes = {
    email = "valebes@gmail.com";
    github = "valebes";
    githubId = 10956211;
    name = "Valerio Besozzi";
  };
  valeriangalliat = {
    email = "val@codejam.info";
    github = "valeriangalliat";
    githubId = 3929133;
    name = "Valérian Galliat";
  };
  valodim = {
    email = "look@my.amazin.horse";
    matrix = "@Valodim:stratum0.org";
    github = "Valodim";
    githubId = 27813;
    name = "Vincent Breitmoser";
  };
  vandenoever = {
    email = "jos@vandenoever.info";
    github = "vandenoever";
    githubId = 608417;
    name = "Jos van den Oever";
  };
  vanilla = {
    email = "osu_vanilla@126.com";
    github = "VergeDX";
    githubId = 25173827;
    name = "Vanilla";
    keys = [{
      fingerprint = "2649 340C C909 F821 D251  6714 3750 028E D04F A42E";
    }];
  };
  vanschelven = {
    email = "klaas@vanschelven.com";
    github = "vanschelven";
    githubId = 223833;
    name = "Klaas van Schelven";
  };
  vanzef = {
    email = "vanzef@gmail.com";
    github = "vanzef";
    githubId = 12428837;
    name = "Ivan Solyankin";
  };
  varunpatro = {
    email = "varun.kumar.patro@gmail.com";
    github = "varunpatro";
    githubId = 6943308;
    name = "Varun Patro";
  };
  vbgl = {
    email = "Vincent.Laporte@gmail.com";
    github = "vbgl";
    githubId = 2612464;
    name = "Vincent Laporte";
  };
  vbmithr = {
    email = "vb@luminar.eu.org";
    github = "vbmithr";
    githubId = 797581;
    name = "Vincent Bernardoff";
  };
  vcanadi = {
    email = "vito.canadi@gmail.com";
    github = "vcanadi";
    githubId = 8889722;
    name = "Vitomir Čanadi";
  };
  vcunat = {
    name = "Vladimír Čunát";
    # vcunat@gmail.com predominated in commits before 2019/03
    email = "v@cunat.cz";
    matrix = "@vcunat:matrix.org";
    github = "vcunat";
    githubId = 1785925;
    keys = [{
      fingerprint = "B600 6460 B60A 80E7 8206  2449 E747 DF1F 9575 A3AA";
    }];
  };
  vdemeester = {
    email = "vincent@sbr.pm";
    github = "vdemeester";
    githubId = 6508;
    name = "Vincent Demeester";
  };
  veehaitch = {
    name = "Vincent Haupert";
    email = "mail@vincent-haupert.de";
    github = "veehaitch";
    githubId = 15069839;
    keys = [{
      fingerprint = "4D23 ECDF 880D CADF 5ECA  4458 874B D6F9 16FA A742";
    }];
  };
  vel = {
    email = "llathasa@outlook.com";
    github = "q60";
    githubId = 61933599;
    name = "vel";
  };
  velovix = {
    email = "xaviosx@gmail.com";
    github = "velovix";
    githubId = 2856634;
    name = "Tyler Compton";
  };
  veprbl = {
    email = "veprbl@gmail.com";
    github = "veprbl";
    githubId = 245573;
    name = "Dmitry Kalinkin";
  };
  victormignot = {
    email = "root@victormignot.fr";
    github = "victormignot";
    githubId = 58660971;
    name = "Victor Mignot";
    keys = [{
      fingerprint = "CA5D F91A D672 683A 1F65  BBC9 0317 096D 20E0 067B";
    }];
  };
  vidbina = {
    email = "vid@bina.me";
    github = "vidbina";
    githubId = 335406;
    name = "David Asabina";
  };
  vidister = {
    email = "v@vidister.de";
    github = "vidister";
    githubId = 11413574;
    name = "Fiona Weber";
  };
  vifino = {
    email = "vifino@tty.sh";
    github = "vifino";
    githubId = 5837359;
    name = "Adrian Pistol";
  };
  vikanezrimaya = {
    email = "vika@fireburn.ru";
    github = "vikanezrimaya";
    githubId = 7953163;
    name = "Vika Shleina";
    keys = [{
      fingerprint = "B3C0 DA1A C18B 82E8 CA8B  B1D1 4F62 CD07 CE64 796A";
    }];
  };
  vincentbernat = {
    email = "vincent@bernat.ch";
    github = "vincentbernat";
    githubId = 631446;
    name = "Vincent Bernat";
    keys = [{
      fingerprint = "AEF2 3487 66F3 71C6 89A7  3600 95A4 2FE8 3535 25F9";
    }];
  };
  vinymeuh = {
    email = "vinymeuh@gmail.com";
    github = "vinymeuh";
    githubId = 118959;
    name = "VinyMeuh";
  };
  virchau13 = {
    email = "virchau13@hexular.net";
    github = "virchau13";
    githubId = 16955157;
    name = "Vir Chaudhury";
  };
  viraptor = {
    email = "nix@viraptor.info";
    github = "viraptor";
    githubId = 188063;
    name = "Stanisław Pitucha";
  };
  viric = {
    email = "viric@viric.name";
    github = "viric";
    githubId = 66664;
    name = "Lluís Batlle i Rossell";
  };
  virusdave = {
    email = "dave.nicponski@gmail.com";
    github = "virusdave";
    githubId = 6148271;
    name = "Dave Nicponski";
  };
  vizanto = {
    email = "danny@prime.vc";
    github = "vizanto";
    githubId = 326263;
    name = "Danny Wilson";
  };
  vklquevs = {
    email = "vklquevs@gmail.com";
    github = "vklquevs";
    githubId = 1771234;
    name = "vklquevs";
  };
  vlaci = {
    email = "laszlo.vasko@outlook.com";
    github = "vlaci";
    githubId = 1771332;
    name = "László Vaskó";
  };
  vlinkz = {
    email = "vmfuentes64@gmail.com";
    github = "vlinkz";
    githubId = 20145996;
    name = "Victor Fuentes";
  };
  vlstill = {
    email = "xstill@fi.muni.cz";
    github = "vlstill";
    githubId = 4070422;
    name = "Vladimír Štill";
  };
  vmandela = {
    email = "venkat.mandela@gmail.com";
    github = "vmandela";
    githubId = 849772;
    name = "Venkateswara Rao Mandela";
  };
  vmchale = {
    email = "tmchale@wisc.edu";
    github = "vmchale";
    githubId = 13259982;
    name = "Vanessa McHale";
  };

  voidless = {
    email = "julius.schmitt@yahoo.de";
    github = "voidIess";
    githubId = 45292658;
    name = "Julius Schmitt";
  };
  vojta001 = {
    email = "vojtech.kane@gmail.com";
    github = "vojta001";
    githubId = 7038383;
    name = "Vojta Káně";
  };
  volhovm = {
    email = "volhovm.cs@gmail.com";
    github = "volhovm";
    githubId = 5604643;
    name = "Mikhail Volkhov";
  };
  vonfry = {
    email = "nixos@vonfry.name";
    github = "Vonfry";
    githubId = 3413119;
    name = "Vonfry";
  };
  vq = {
    email = "vq@erq.se";
    github = "vq";
    githubId = 230381;
    name = "Daniel Nilsson";
  };
  vrinek = {
    email = "vrinek@hey.com";
    github = "vrinek";
    name = "Kostas Karachalios";
    githubId = 81346;
  };
  vrthra = {
    email = "rahul@gopinath.org";
    github = "vrthra";
    githubId = 70410;
    name = "Rahul Gopinath";
  };
  vskilet = {
    email = "victor@sene.ovh";
    github = "Vskilet";
    githubId = 7677567;
    name = "Victor SENE";
  };
  vtuan10 = {
    email = "mail@tuan-vo.de";
    github = "vtuan10";
    githubId = 16415673;
    name = "Van Tuan Vo";
  };
  vyorkin = {
    email = "vasiliy.yorkin@gmail.com";
    github = "vyorkin";
    githubId = 988849;
    name = "Vasiliy Yorkin";
  };
  vyp = {
    email = "elisp.vim@gmail.com";
    github = "vyp";
    githubId = 3889405;
    name = "vyp";
  };
  wackbyte = {
    name = "wackbyte";
    email = "wackbyte@pm.me";
    github = "wackbyte";
    githubId = 29505620;
    keys = [{
      fingerprint = "E595 7FE4 FEF6 714B 1AD3  1483 937F 2AE5 CCEF BF59";
    }];
  };
  wakira = {
    name = "Sheng Wang";
    email = "sheng@a64.work";
    github = "wakira";
    githubId = 2338339;
    keys = [{
      fingerprint = "47F7 009E 3AE3 1DA7 988E  12E1 8C9B 0A8F C0C0 D862";
    }];
  };
  wamserma = {
    name = "Markus S. Wamser";
    email = "github-dev@mail2013.wamser.eu";
    github = "wamserma";
    githubId = 60148;
  };
  water-sucks = {
    email = "varun@cvte.org";
    name = "Varun Narravula";
    github = "water-sucks";
    githubId = 68445574;
  };
  waynr = {
    name = "Wayne Warren";
    email = "wayne.warren.s@gmail.com";
    github = "waynr";
    githubId = 1441126;
  };
  wchresta = {
    email = "wchresta.nix@chrummibei.ch";
    github = "wchresta";
    githubId = 34962284;
    name = "wchresta";
  };
  wdavidw = {
    name = "David Worms";
    email = "david@adaltas.com";
    github = "wdavidw";
    githubId = 46896;
  };
  WeebSorceress = {
    name = "WeebSorceress";
    email = "hello@weebsorceress.anonaddy.me";
    matrix = "@weebsorceress:matrix.org";
    github = "WeebSorceress";
    githubId = 106774777;
    keys = [{
      fingerprint = "659A 9BC3 F904 EC24 1461  2EFE 7F57 3443 17F0 FA43";
    }];
  };
  wegank = {
    name = "Weijia Wang";
    email = "contact@weijia.wang";
    github = "wegank";
    githubId = 9713184;
  };
  weihua = {
    email = "luwh364@gmail.com";
    github = "weihua-lu";
    githubId = 9002575;
    name = "Weihua Lu";
  };
  welteki = {
    email = "welteki@pm.me";
    github = "welteki";
    githubId = 16267532;
    name = "Han Verstraete";
    keys = [{
      fingerprint = "2145 955E 3F5E 0C95 3458  41B5 11F7 BAEA 8567 43FF";
    }];
  };
  wentam = {
    name = "Matt Egeler";
    email = "wentam42@gmail.com";
    github = "wentam";
    githubId = 901583;
  };
  wentasah = {
    name = "Michal Sojka";
    email = "wsh@2x.cz";
    github = "wentasah";
    githubId = 140542;
  };
  wesnel = {
    name = "Wesley Nelson";
    email = "wgn@wesnel.dev";
    github = "wesnel";
    githubId = 43357387;
    keys = [{
      fingerprint = "F844 80B2 0CA9 D6CC C7F5  2479 A776 D2AD 099E 8BC0";
    }];
  };
  wheelsandmetal = {
    email = "jakob@schmutz.co.uk";
    github = "wheelsandmetal";
    githubId = 13031455;
    name = "Jakob Schmutz";
  };
  WhittlesJr = {
    email = "alex.joseph.whitt@gmail.com";
    github = "WhittlesJr";
    githubId = 19174984;
    name = "Alex Whitt";
  };
  whonore = {
    email = "wolfhonore@gmail.com";
    github = "whonore";
    githubId = 7121530;
    name = "Wolf Honoré";
  };
  wildsebastian = {
    name = "Sebastian Wild";
    email = "sebastian@wild-siena.com";
    github = "wildsebastian";
    githubId = 1215623;
    keys = [{
      fingerprint = "DA03 D6C6 3F58 E796 AD26  E99B 366A 2940 479A 06FC";
    }];
  };
  willibutz = {
    email = "willibutz@posteo.de";
    github = "WilliButz";
    githubId = 20464732;
    name = "Willi Butz";
  };
  willcohen = {
    email = "willcohen@users.noreply.github.com";
    github = "willcohen";
    githubId = 5185341;
    name = "Will Cohen";
  };
  winpat = {
    email = "patrickwinter@posteo.ch";
    github = "winpat";
    githubId = 6016963;
    name = "Patrick Winter";
  };
  winter = {
    email = "nixos@winter.cafe";
    github = "winterqt";
    githubId = 78392041;
    name = "Winter";
  };
  wintrmvte = {
    name = "Jakub Lutczyn";
    email = "kubalutczyn@gmail.com";
    github = "wintrmvte";
    githubId = 41823252;
  };
  wirew0rm = {
    email = "alex@wirew0rm.de";
    github = "wirew0rm";
    githubId = 1202371;
    name = "Alexander Krimm";
  };
  wishfort36 = {
    email = "42300264+wishfort36@users.noreply.github.com";
    github = "wishfort36";
    githubId = 42300264;
    name = "wishfort36";
  };
  wizeman = {
    email = "rcorreia@wizy.org";
    github = "wizeman";
    githubId = 168610;
    name = "Ricardo M. Correia";
  };
  wjlroe = {
    email = "willroe@gmail.com";
    github = "wjlroe";
    githubId = 43315;
    name = "William Roe";
  };
  wldhx = {
    email = "wldhx+nixpkgs@wldhx.me";
    github = "wldhx";
    githubId = 15619766;
    name = "wldhx";
  };
  wmertens = {
    email = "Wout.Mertens@gmail.com";
    github = "wmertens";
    githubId = 54934;
    name = "Wout Mertens";
  };
  wnklmnn = {
    email = "pascal@wnklmnn.de";
    github = "wnklmnn";
    githubId = 9423014;
    name = "Pascal Winkelmann";
  };
  woffs = {
    email = "github@woffs.de";
    github = "woffs";
    githubId = 895853;
    name = "Frank Doepper";
  };
  wohanley = {
    email = "me@wohanley.com";
    github = "wohanley";
    githubId = 1322287;
    name = "William O'Hanley";
  };
  woky = {
    email = "pampu.andrei@pm.me";
    github = "andreisergiu98";
    githubId = 11740700;
    name = "Andrei Pampu";
  };
  wolfangaukang = {
    email = "clone.gleeful135+nixpkgs@anonaddy.me";
    github = "WolfangAukang";
    githubId = 8378365;
    name = "P. R. d. O.";
  };
  womfoo = {
    email = "kranium@gikos.net";
    github = "womfoo";
    githubId = 1595132;
    name = "Kranium Gikos Mendoza";
  };
  worldofpeace = {
    email = "worldofpeace@protonmail.ch";
    github = "worldofpeace";
    githubId = 28888242;
    name = "WORLDofPEACE";
  };
  wozeparrot = {
    email = "wozeparrot@gmail.com";
    github = "wozeparrot";
    githubId = 25372613;
    name = "Woze Parrot";
  };
  wr0belj = {
    name = "Jakub Wróbel";
    email = "wrobel.jakub@protonmail.com";
    github = "wr0belj";
    githubId = 40501814;
  };
  wrmilling = {
    name = "Winston R. Milling";
    email = "Winston@Milli.ng";
    github = "wrmilling";
    githubId = 6162814;
    keys = [{
      fingerprint = "21E1 6B8D 2EE8 7530 6A6C  9968 D830 77B9 9F8C 6643";
    }];
  };
  wscott = {
    email = "wsc9tt@gmail.com";
    github = "wscott";
    githubId = 31487;
    name = "Wayne Scott";
  };
  wucke13 = {
    email = "wucke13@gmail.com";
    github = "wucke13";
    githubId = 20400405;
    name = "Wucke";
  };
  wykurz = {
    email = "wykurz@gmail.com";
    github = "wykurz";
    githubId = 483465;
    name = "Mateusz Wykurz";
  };
  wulfsta = {
    email = "wulfstawulfsta@gmail.com";
    github = "Wulfsta";
    githubId = 13378502;
    name = "Wulfsta";
  };
  wunderbrick = {
    name = "Andrew Phipps";
    email = "lambdafuzz@tutanota.com";
    github = "wunderbrick";
    githubId = 52174714;
  };
  wyndon = {
    email = "72203260+wyndon@users.noreply.github.com";
    matrix = "@wyndon:envs.net";
    github = "wyndon";
    githubId = 72203260;
    name = "wyndon";
  };
  wyvie = {
    email = "elijahrum@gmail.com";
    github = "alicerum";
    githubId = 3992240;
    name = "Elijah Rum";
  };
  x3ro = {
    name = "^x3ro";
    email = "nix@x3ro.dev";
    github = "x3rAx";
    githubId = 2268851;
  };
  xanderio = {
    name = "Alexander Sieg";
    email = "alex@xanderio.de";
    github = "xanderio";
    githubId = 6298052;
  };
  xaverdh = {
    email = "hoe.dom@gmx.de";
    github = "xaverdh";
    githubId = 11050617;
    name = "Dominik Xaver Hörl";
  };
  xbreak = {
    email = "xbreak@alphaware.se";
    github = "xbreak";
    githubId = 13489144;
    name = "Calle Rosenquist";
  };
  xdhampus = {
    name = "Hampus";
    email = "16954508+xdHampus@users.noreply.github.com";
    github = "xdHampus";
    githubId = 16954508;
  };
  xe = {
    email = "me@christine.website";
    matrix = "@withoutwithin:matrix.org";
    github = "Xe";
    githubId = 529003;
    name = "Christine Dodrill";
  };
  xeji = {
    email = "xeji@cat3.de";
    github = "xeji";
    githubId = 36407913;
    name = "Uli Baum";
  };
  xfnw = {
    email = "xfnw+nixos@riseup.net";
    github = "xfnw";
    githubId = 66233223;
    name = "Owen";
  };
  xfix = {
    email = "konrad@borowski.pw";
    matrix = "@xfix:matrix.org";
    github = "xfix";
    githubId = 1297598;
    name = "Konrad Borowski";
  };
  xgroleau = {
    email = "xgroleau@gmail.com";
    github = "xgroleau";
    githubId = 31734358;
    name = "Xavier Groleau";
  };
  xiorcale = {
    email = "quentin.vaucher@pm.me";
    github = "xiorcale";
    githubId = 17534323;
    name = "Quentin Vaucher";
  };
  xnaveira = {
    email = "xnaveira@gmail.com";
    github = "xnaveira";
    githubId = 2534411;
    name = "Xavier Naveira";
  };
  xnwdd = {
    email = "nwdd+nixos@no.team";
    github = "xNWDD";
    githubId = 3028542;
    name = "Guillermo NWDD";
  };
  xrelkd = {
    email = "46590321+xrelkd@users.noreply.github.com";
    github = "xrelkd";
    githubId = 46590321;
    name = "xrelkd";
  };
  xurei = {
    email = "olivier.bourdoux@gmail.com";
    github = "xurei";
    githubId = 621695;
    name = "Olivier Bourdoux";
  };
  xvapx = {
    email = "marti.serra.coscollano@gmail.com";
    github = "xvapx";
    githubId = 11824817;
    name = "Marti Serra";
  };
  xworld21 = {
    email = "1962985+xworld21@users.noreply.github.com";
    github = "xworld21";
    githubId = 1962985;
    name = "Vincenzo Mantova";
  };
  xyenon = {
    name = "XYenon";
    email = "i@xyenon.bid";
    github = "XYenon";
    githubId = 20698483;
  };
  xzfc = {
    email = "xzfcpw@gmail.com";
    github = "xzfc";
    githubId = 5121426;
    name = "Albert Safin";
  };
  y0no = {
    email = "y0no@y0no.fr";
    github = "y0no";
    githubId = 2242427;
    name = "Yoann Ono";
  };
  yana = {
    email = "yana@riseup.net";
    github = "yanalunaterra";
    githubId = 1643293;
    name = "Yana Timoshenko";
  };
  yarny = {
    email = "41838844+Yarny0@users.noreply.github.com";
    github = "Yarny0";
    githubId = 41838844;
    name = "Yarny";
  };
  yarr = {
    email = "savraz@gmail.com";
    github = "Eternity-Yarr";
    githubId = 3705333;
    name = "Dmitry V.";
  };
  yayayayaka = {
    email = "nixpkgs@uwu.is";
    matrix = "@lara:uwu.is";
    github = "yayayayaka";
    githubId = 73759599;
    name = "Lara A.";
  };
  yesbox = {
    email = "jesper.geertsen.jonsson@gmail.com";
    github = "yesbox";
    githubId = 4113027;
    name = "Jesper Geertsen Jonsson";
  };
  yinfeng = {
    email = "lin.yinfeng@outlook.com";
    github = "linyinfeng";
    githubId = 11229748;
    name = "Lin Yinfeng";
  };
  ylecornec = {
    email = "yves.stan.lecornec@tweag.io";
    github = "ylecornec";
    githubId = 5978566;
    name = "Yves-Stan Le Cornec";
  };
  ylh = {
    email = "nixpkgs@ylh.io";
    github = "ylh";
    githubId = 9125590;
    name = "Yestin L. Harrison";
  };
  ylwghst = {
    email = "ylwghst@onionmail.info";
    github = "ylwghst";
    githubId = 26011724;
    name = "Burim Augustin Berisa";
  };
  yl3dy = {
    email = "aleksandr.kiselyov@gmail.com";
    github = "yl3dy";
    githubId = 1311192;
    name = "Alexander Kiselyov";
  };
  yochai = {
    email = "yochai@titat.info";
    github = "yochai";
    githubId = 1322201;
    name = "Yochai";
  };
  yoctocell = {
    email = "public@yoctocell.xyz";
    github = "yoctocell";
    githubId = 40352765;
    name = "Yoctocell";
  };
  yorickvp = {
    email = "yorickvanpelt@gmail.com";
    matrix = "@yorickvp:matrix.org";
    github = "yorickvP";
    githubId = 647076;
    name = "Yorick van Pelt";
  };
  yrashk = {
    email = "yrashk@gmail.com";
    github = "yrashk";
    githubId = 452;
    name = "Yurii Rashkovskii";
  };
  yrd = {
    name = "Yannik Rödel";
    email = "nix@yannik.info";
    github = "yrd";
    githubId = 1820447;
  };
  ysndr = {
    email = "me@ysndr.de";
    github = "ysndr";
    githubId = 7040031;
    name = "Yannik Sander";
  };
  yureien = {
    email = "contact@sohamsen.me";
    github = "Yureien";
    githubId = 17357089;
    name = "Soham Sen";
  };
  yuriaisaka = {
    email = "yuri.aisaka+nix@gmail.com";
    github = "yuriaisaka";
    githubId = 687198;
    name = "Yuri Aisaka";
  };
  yurkobb = {
    name = "Yury Bulka";
    email = "setthemfree@privacyrequired.com";
    github = "yurkobb";
    githubId = 479389;
  };
  yurrriq = {
    email = "eric@ericb.me";
    github = "yurrriq";
    githubId = 1866448;
    name = "Eric Bailey";
  };
  Yumasi = {
    email = "gpagnoux@gmail.com";
    github = "Yumasi";
    githubId = 24368641;
    name = "Guillaume Pagnoux";
    keys = [{
      fingerprint = "85F8 E850 F8F2 F823 F934  535B EC50 6589 9AEA AF4C";
    }];
  };
  yuka = {
    email = "yuka@yuka.dev";
    matrix = "@yuka:yuka.dev";
    github = "yu-re-ka";
    githubId = 86169957;
    name = "Yureka";
  };
  yusdacra = {
    email = "y.bera003.06@protonmail.com";
    matrix = "@yusdacra:nixos.dev";
    github = "yusdacra";
    githubId = 19897088;
    name = "Yusuf Bera Ertan";
    keys = [{
      fingerprint = "9270 66BD 8125 A45B 4AC4 0326 6180 7181 F60E FCB2";
    }];
  };
  yuu = {
    email = "yuuyin@protonmail.com";
    github = "yuuyins";
    githubId = 86538850;
    name = "Yuu Yin";
    keys = [{
      fingerprint = "9F19 3AE8 AA25 647F FC31  46B5 416F 303B 43C2 0AC3";
    }];
  };
  yvesf = {
    email = "yvesf+nix@xapek.org";
    github = "yvesf";
    githubId = 179548;
    name = "Yves Fischer";
  };
  yvt = {
    email = "i@yvt.jp";
    github = "yvt";
    githubId = 5253988;
    name = "yvt";
  };
  maggesi = {
    email = "marco.maggesi@gmail.com";
    github = "maggesi";
    githubId = 1809783;
    name = "Marco Maggesi";
  };
  zachcoyle = {
    email = "zach.coyle@gmail.com";
    github = "zachcoyle";
    githubId = 908716;
    name = "Zach Coyle";
  };
  zagy = {
    email = "cz@flyingcircus.io";
    github = "zagy";
    githubId = 568532;
    name = "Christian Zagrodnick";
  };
  zakame = {
    email = "zakame@zakame.net";
    github = "zakame";
    githubId = 110625;
    name = "Zak B. Elep";
  };
  zalakain = {
    email = "ping@umazalakain.info";
    github = "umazalakain";
    githubId = 1319905;
    name = "Uma Zalakain";
  };
  zaninime = {
    email = "francesco@zanini.me";
    github = "zaninime";
    githubId = 450885;
    name = "Francesco Zanini";
  };
  zarelit = {
    email = "david@zarel.net";
    github = "zarelit";
    githubId = 3449926;
    name = "David Costa";
  };
  zauberpony = {
    email = "elmar@athmer.org";
    github = "elmarx";
    githubId = 250877;
    name = "Elmar Athmer";
  };
  zakkor = {
    email = "edward.dalbon@gmail.com";
    github = "zakkor";
    githubId = 6191421;
    name = "Edward d'Albon";
  };
  zebreus = {
    matrix = "@lennart:cicen.net";
    email = "lennarteichhorn+nixpkgs@gmail.com";
    github = "Zebreus";
    githubId = 1557253;
    name = "Lennart Eichhorn";
  };
  zeratax = {
    email = "mail@zera.tax";
    github = "zeratax";
    githubId = 5024958;
    name = "Jona Abdinghoff";
    keys = [{
      fingerprint = "44F7 B797 9D3A 27B1 89E0  841E 8333 735E 784D F9D4";
    }];
  };
  zfnmxt = {
    name = "zfnmxt";
    email = "zfnmxt@zfnmxt.com";
    github = "zfnmxt";
    githubId = 37446532;
  };
  zgrannan = {
    email = "zgrannan@gmail.com";
    github = "zgrannan";
    githubId = 1141948;
    name = "Zack Grannan";
  };
  zhaofengli = {
    email = "hello@zhaofeng.li";
    matrix = "@zhaofeng:zhaofeng.li";
    github = "zhaofengli";
    githubId = 2189609;
    name = "Zhaofeng Li";
  };
  zimbatm = {
    email = "zimbatm@zimbatm.com";
    github = "zimbatm";
    githubId = 3248;
    name = "zimbatm";
  };
  Zimmi48 = {
    email = "theo.zimmermann@univ-paris-diderot.fr";
    github = "Zimmi48";
    githubId = 1108325;
    name = "Théo Zimmermann";
  };
  zohl = {
    email = "zohl@fmap.me";
    github = "zohl";
    githubId = 6067895;
    name = "Al Zohali";
  };
  zookatron = {
    email = "tim@zookatron.com";
    github = "zookatron";
    githubId = 1772064;
    name = "Tim Zook";
  };
  zopieux = {
    email = "zopieux@gmail.com";
    github = "zopieux";
    githubId = 81353;
    name = "Alexandre Macabies";
  };
  zowoq = {
    email = "59103226+zowoq@users.noreply.github.com";
    github = "zowoq";
    githubId = 59103226;
    name = "zowoq";
  };
  zraexy = {
    email = "zraexy@gmail.com";
    github = "zraexy";
    githubId = 8100652;
    name = "David Mell";
  };
  ztzg = {
    email = "dd@crosstwine.com";
    github = "ztzg";
    githubId = 393108;
    name = "Damien Diederen";
  };
  zx2c4 = {
    email = "Jason@zx2c4.com";
    github = "zx2c4";
    githubId = 10643;
    name = "Jason A. Donenfeld";
  };
  zyansheep = {
    email = "zyansheep@protonmail.com";
    github = "zyansheep";
    githubId = 20029431;
    name = "Zyansheep";
  };
  zzamboni = {
    email = "diego@zzamboni.org";
    github = "zzamboni";
    githubId = 32876;
    name = "Diego Zamboni";
  };
  turbomack = {
    email = "marek.faj@gmail.com";
    github = "turboMaCk";
    githubId = 2130305;
    name = "Marek Fajkus";
  };
  melling = {
    email = "mattmelling@fastmail.com";
    github = "mattmelling";
    githubId = 1215331;
    name = "Matt Melling";
  };
  wd15 = {
    email = "daniel.wheeler2@gmail.com";
    github = "wd15";
    githubId = 1986844;
    name = "Daniel Wheeler";
  };
  misuzu = {
    email = "bakalolka@gmail.com";
    github = "misuzu";
    githubId = 248143;
    name = "misuzu";
  };
  zokrezyl = {
    email = "zokrezyl@gmail.com";
    github = "zokrezyl";
    githubId = 51886259;
    name = "Zokre Zyl";
  };
  rakesh4g = {
    email = "rakeshgupta4u@gmail.com";
    github = "Rakesh4G";
    githubId = 50867187;
    name = "Rakesh Gupta";
  };
  mlatus = {
    email = "wqseleven@gmail.com";
    github = "Ninlives";
    githubId = 17873203;
    name = "mlatus";
  };
  waiting-for-dev = {
    email = "marc@lamarciana.com";
    github = "waiting-for-dev";
    githubId = 52650;
    name = "Marc Busqué";
  };
  snglth = {
    email = "illia@ishestakov.com";
    github = "snglth";
    githubId = 8686360;
    name = "Illia Shestakov";
  };
  masaeedu = {
    email = "masaeedu@gmail.com";
    github = "masaeedu";
    githubId = 3674056;
    name = "Asad Saeeduddin";
  };
  matthewcroughan = {
    email = "matt@croughan.sh";
    github = "MatthewCroughan";
    githubId = 26458780;
    name = "Matthew Croughan";
  };
  ngerstle = {
    name = "Nicholas Gerstle";
    email = "ngerstle@gmail.com";
    github = "ngerstle";
    githubId = 1023752;
  };
  shardy = {
    email = "shardul@baral.ca";
    github = "shardulbee";
    githubId = 16765155;
    name = "Shardul Baral";
  };
  xavierzwirtz = {
    email = "me@xavierzwirtz.com";
    github = "xavierzwirtz";
    githubId = 474343;
    name = "Xavier Zwirtz";
  };
  ymarkus = {
    name = "Yannick Markus";
    email = "nixpkgs@ymarkus.dev";
    github = "ymarkus";
    githubId = 62380378;
  };
  ymatsiuk = {
    name = "Yurii Matsiuk";
    email = "ymatsiuk@users.noreply.github.com";
    github = "ymatsiuk";
    githubId = 24990891;
    keys = [{
      fingerprint = "7BB8 84B5 74DA FDB1 E194  ED21 6130 2290 2986 01AA";
    }];
  };
  ymeister = {
    name = "Yuri Meister";
    email = "47071325+ymeister@users.noreply.github.com";
    github = "ymeister";
    githubId = 47071325;
  };
  cpcloud = {
    name = "Phillip Cloud";
    email = "417981+cpcloud@users.noreply.github.com";
    github = "cpcloud";
    githubId = 417981;
  };
  davegallant = {
    name = "Dave Gallant";
    email = "davegallant@gmail.com";
    github = "davegallant";
    githubId = 4519234;
  };
  saulecabrera = {
    name = "Saúl Cabrera";
    email = "saulecabrera@gmail.com";
    github = "saulecabrera";
    githubId = 1423601;
  };
  tfmoraes = {
    name = "Thiago Franco de Moraes";
    email = "351108+tfmoraes@users.noreply.github.com";
    github = "tfmoraes";
    githubId = 351108;
  };
  deifactor = {
    name = "Ash Zahlen";
    email = "ext0l@riseup.net";
    github = "deifactor";
    githubId = 30192992;
  };
  deinferno = {
    name = "deinferno";
    email = "14363193+deinferno@users.noreply.github.com";
    github = "deinferno";
    githubId = 14363193;
  };
  fzakaria = {
    name = "Farid Zakaria";
    email = "farid.m.zakaria@gmail.com";
    matrix = "@fzakaria:matrix.org";
    github = "fzakaria";
    githubId = 605070;
  };
  nagisa = {
    name = "Simonas Kazlauskas";
    email = "nixpkgs@kazlauskas.me";
    github = "nagisa";
    githubId = 679122;
  };
  yshym = {
    name = "Yevhen Shymotiuk";
    email = "yshym@pm.me";
    github = "yshym";
    githubId = 44244245;
  };
  hmenke = {
    name = "Henri Menke";
    email = "henri@henrimenke.de";
    matrix = "@hmenke:matrix.org";
    github = "hmenke";
    githubId = 1903556;
    keys = [{
      fingerprint = "F1C5 760E 45B9 9A44 72E9  6BFB D65C 9AFB 4C22 4DA3";
    }];
  };
  berbiche = {
    name = "Nicolas Berbiche";
    email = "nicolas@normie.dev";
    github = "berbiche";
    githubId = 20448408;
    keys = [{
      fingerprint = "D446 E58D 87A0 31C7 EC15  88D7 B461 2924 45C6 E696";
    }];
  };
  wenngle = {
    name = "Zeke Stephens";
    email = "zekestephens@gmail.com";
    github = "wenngle";
    githubId = 63376671;
  };
  yanganto = {
    name = "Antonio Yang";
    email = "yanganto@gmail.com";
    github = "yanganto";
    githubId = 10803111;
  };
  starcraft66 = {
    name = "Tristan Gosselin-Hane";
    email = "starcraft66@gmail.com";
    github = "starcraft66";
    githubId = 1858154;
    keys = [{
      fingerprint = "8597 4506 EC69 5392 0443  0805 9D98 CDAC FF04 FD78";
    }];
  };
  hloeffler = {
    name = "Hauke Löffler";
    email = "nix@hauke-loeffler.de";
    github = "hloeffler";
    githubId = 6627191;
  };
  wilsonehusin = {
    name = "Wilson E. Husin";
    email = "wilsonehusin@gmail.com";
    github = "wilsonehusin";
    githubId = 14004487;
  };
  bb2020 = {
    email = "bb2020@users.noreply.github.com";
    github = "bb2020";
    githubId = 19290397;
    name = "Tunc Uzlu";
  };
  pulsation = {
    name = "Philippe Sam-Long";
    email = "1838397+pulsation@users.noreply.github.com";
    github = "pulsation";
    githubId = 1838397;
  };
  princemachiavelli = {
    name = "Josh Hoffer";
    email = "jhoffer@sansorgan.es";
    matrix = "@princemachiavelli:matrix.org";
    github = "Princemachiavelli";
    githubId = 2730968;
    keys = [{
      fingerprint = "DD54 130B ABEC B65C 1F6B  2A38 8312 4F97 A318 EA18";
    }];
  };
  ydlr = {
    name = "ydlr";
    email = "ydlr@ydlr.io";
    github = "ydlr";
    githubId = 58453832;
    keys = [{
      fingerprint = "FD0A C425 9EF5 4084 F99F 9B47 2ACC 9749 7C68 FAD4";
    }];
  };
  zane = {
    name = "Zane van Iperen";
    email = "zane@zanevaniperen.com";
    github = "vs49688";
    githubId = 4423262;
    keys = [{
      fingerprint = "61AE D40F 368B 6F26 9DAE  3892 6861 6B2D 8AC4 DCC5";
    }];
  };
  zbioe = {
    name = "Iury Fukuda";
    email = "zbioe@protonmail.com";
    github = "zbioe";
    githubId = 7332055;
  };
  zendo = {
    name = "zendo";
    email = "linzway@qq.com";
    github = "zendo";
    githubId = 348013;
  };
  zenithal = {
    name = "zenithal";
    email = "i@zenithal.me";
    github = "ZenithalHourlyRate";
    githubId = 19512674;
    keys = [{
      fingerprint = "1127 F188 280A E312 3619  3329 87E1 7EEF 9B18 B6C9";
    }];
  };
  zeri = {
    name = "zeri";
    email = "68825133+zeri42@users.noreply.github.com";
    matrix = "@zeri:matrix.org";
    github = "zeri42";
    githubId = 68825133;
  };
  zoedsoupe = {
    github = "zoedsoupe";
    githubId = 44469426;
    name = "Zoey de Souza Pessanha";
    email = "zoey.spessanha@outlook.com";
    keys = [{
      fingerprint = "EAA1 51DB 472B 0122 109A  CB17 1E1E 889C DBD6 A315";
    }];
  };
  zombiezen = {
    name = "Ross Light";
    email = "ross@zombiezen.com";
    github = "zombiezen";
    githubId = 181535;
  };
  zseri = {
    name = "zseri";
    email = "zseri.devel@ytrizja.de";
    github = "zseri";
    githubId = 1618343;
    keys = [{
      fingerprint = "7AFB C595 0D3A 77BD B00F  947B 229E 63AE 5644 A96D";
    }];
  };
  zupo = {
    name = "Nejc Zupan";
    email = "nejczupan+nix@gmail.com";
    github = "zupo";
    githubId = 311580;
  };
  sei40kr = {
    name = "Seong Yong-ju";
    email = "sei40kr@gmail.com";
    github = "sei40kr";
    githubId = 11665236;
  };
  vdot0x23 = {
    name = "Victor Büttner";
    email = "nix.victor@0x23.dk";
    github = "vdot0x23";
    githubId = 40716069;
  };
  jpagex = {
    name = "Jérémy Pagé";
    email = "contact@jeremypage.me";
    github = "jpagex";
    githubId = 635768;
  };
  vbrandl = {
    name = "Valentin Brandl";
    email = "mail+nixpkgs@vbrandl.net";
    github = "vbrandl";
    githubId = 20639051;
  };
  portothree = {
    name = "Gustavo Porto";
    email = "gus@p8s.co";
    github = "portothree";
    githubId = 3718120;
  };
  pwoelfel = {
    name = "Philipp Woelfel";
    email = "philipp.woelfel@gmail.com";
    github = "PhilippWoelfel";
    githubId = 19400064;
  };
  qbit = {
    name = "Aaron Bieber";
    email = "aaron@bolddaemon.com";
    github = "qbit";
    githubId = 68368;
    matrix = "@qbit:tapenet.org";
    keys = [{
      fingerprint = "3586 3350 BFEA C101 DB1A 4AF0 1F81 112D 62A9 ADCE";
    }];
  };
  ameer = {
    name = "Ameer Taweel";
    email = "ameertaweel2002@gmail.com";
    github = "AmeerTaweel";
    githubId = 20538273;
  };
  nigelgbanks = {
    name = "Nigel Banks";
    email = "nigel.g.banks@gmail.com";
    github = "nigelgbanks";
    githubId = 487373;
  };
  zanculmarktum = {
    name = "Azure Zanculmarktum";
    email = "zanculmarktum@gmail.com";
    github = "zanculmarktum";
    githubId = 16958511;
  };
  kuwii = {
    name = "kuwii";
    email = "kuwii.someone@gmail.com";
    github = "kuwii";
    githubId = 10705175;
  };
  kkharji = {
    name = "kkharji";
    email = "kkharji@protonmail.com";
    github = "kkharji";
    githubId = 65782666;
  };
  melias122 = {
    name = "Martin Elias";
    email = "martin+nixpkgs@elias.sx";
    github = "melias122";
    githubId = 1027766;
  };
  bryanhonof = {
    name = "Bryan Honof";
    email = "bryanhonof@gmail.com";
    github = "bryanhonof";
    githubId = 5932804;
  };
  bbenne10 = {
    email = "Bryan.Bennett@protonmail.com";
    matrix = "@bryan.bennett:matrix.org";
    github = "bbenne10";
    githubId = 687376;
    name = "Bryan Bennett";
    keys = [{
      # compare with https://keybase.io/bbenne10
      fingerprint = "41EA 00B4 00F9 6970 1CB2  D3AF EF90 E3E9 8B8F 5C0B";
    }];
  };
  snpschaaf = {
    email = "philipe.schaaf@secunet.com";
    name = "Philippe Schaaf";
    github = "snpschaaf";
    githubId = 105843013;
  };
  SohamG = {
    email = "sohamg2@gmail.com";
    name = "Soham S Gumaste";
    github = "SohamG";
    githubId = 7116239;
    keys = [{
      fingerprint = "E067 520F 5EF2 C175 3F60  50C0 BA46 725F 6A26 7442";
    }];
  };
  jali-clarke = {
    email = "jinnah.ali-clarke@outlook.com";
    name = "Jinnah Ali-Clarke";
    github = "jali-clarke";
    githubId = 17733984;
  };
  wesleyjrz = {
    email = "dev@wesleyjrz.com";
    name = "Wesley V. Santos Jr.";
    github = "wesleyjrz";
    githubId = 60184588;
  };
  npatsakula = {
    email = "nikita.patsakula@gmail.com";
    name = "Patsakula Nikita";
    github = "npatsakula";
    githubId = 23001619;
  };
  dfithian = {
    email = "daniel.m.fithian@gmail.com";
    name = "Daniel Fithian";
    github = "dfithian";
    githubId = 8409320;
  };
  nikstur = {
    email = "nikstur@outlook.com";
    name = "nikstur";
    github = "nikstur";
    githubId = 61635709;
  };
  yisuidenghua = {
    email = "bileiner@gmail.com";
    name = "Milena Yisui";
    github = "YisuiDenghua";
    githubId = 102890144;
  };
  macalinao = {
    email = "me@ianm.com";
    name = "Ian Macalinao";
    github = "macalinao";
    githubId = 401263;
    keys = [{
      fingerprint = "1147 43F1 E707 6F3E 6F4B  2C96 B9A8 B592 F126 F8E8";
    }];
  };
  tjni = {
    email = "43ngvg@masqt.com";
    matrix = "@tni:matrix.org";
    name = "Theodore Ni";
    github = "tjni";
    githubId = 3806110;
    keys = [{
      fingerprint = "4384 B8E1 299F C028 1641  7B8F EC30 EFBE FA7E 84A4";
    }];
  };
  bezmuth = {
    email = "benkel97@protonmail.com";
    name = "Ben Kelly";
    github = "bezmuth";
    githubId = 31394095;
  };
  cafkafk = {
    email = "christina@cafkafk.com";
    matrix = "@cafkafk:matrix.cafkafk.com";
    name = "Christina Sørensen";
    github = "cafkafk";
    githubId = 89321978;
    keys = [
      {
        fingerprint = "7B9E E848 D074 AE03 7A0C  651A 8ED4 DEF7 375A 30C8";
      }
      {
        fingerprint = "208A 2A66 8A2F CDE7 B5D3 8F64 CDDC 792F 6552 51ED";
      }
    ];
  };
  rb = {
    email = "maintainers@cloudposse.com";
    github = "nitrocode";
    githubId = 7775707;
    name = "RB";
  };
  bpaulin = {
    email = "brunopaulin@bpaulin.net";
    github = "bpaulin";
    githubId = 115711;
    name = "bpaulin";
  };
  zuzuleinen = {
    email = "andrey.boar@gmail.com";
    name = "Andrei Boar";
    github = "zuzuleinen";
    githubId = 944919;
  };
  waelwindows = {
    email = "waelwindows9922@gmail.com";
    github = "Waelwindows";
    githubId = 5228243;
    name = "waelwindows";
  };
  witchof0x20 = {
    name = "Jade";
    email = "jade@witchof.space";
    github = "witchof0x20";
    githubId = 36118348;
    keys = [{
      fingerprint = "69C9 876B 5797 1B2E 11C5  7C39 80A1 F76F C9F9 54AE";
    }];
  };
  WhiteBlackGoose = {
    email = "wbg@angouri.org";
    github = "WhiteBlackGoose";
    githubId = 31178401;
    name = "WhiteBlackGoose";
    keys = [{
      fingerprint = "640B EDDE 9734 310A BFA3  B257 52ED AE6A 3995 AFAB";
    }];
  };
  wuyoli = {
    name = "wuyoli";
    email = "wuyoli@tilde.team";
    github = "wuyoli";
    githubId = 104238274;
  };
  ziguana = {
    name = "Zig Uana";
    email = "git@ziguana.dev";
    github = "ziguana";
    githubId = 45833444;
  };
  detegr = {
    name = "Antti Keränen";
    email = "detegr@rbx.email";
    github = "Detegr";
    githubId = 724433;
  };
  RossComputerGuy = {
    name = "Tristan Ross";
    email = "tristan.ross@midstall.com";
    github = "RossComputerGuy";
    githubId = 19699320;
  };
  franzmondlichtmann = {
    name = "Franz Schroepf";
    email = "franz-schroepf@t-online.de";
    github = "franzmondlichtmann";
    githubId = 105480088;
  };
}
