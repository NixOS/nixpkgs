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
    name = "Dmitry Kulikov";
    email = "0qqw0qqw@gmail.com";

    github = "0qq";
    githubId = 64707304;
  };
  _0x4A6F = {
    name = "Joachim Ernst";
    email = "mail-maintainer@0x4A6F.dev";

    matrix = "@0x4a6f:matrix.org";
    github = "0x4A6F";
    githubId = 9675338;
    keys = [{
      fingerprint = "F466 A548 AD3F C1F1 8C88  4576 8702 7528 B006 D66D";
    }];
  };
  _0xB10C = {
    name = "0xB10C";
    email = "nixpkgs@b10c.me";

    github = "0xb10c";
    githubId = 19157360;
  };
  _0xbe7a = {
    name = "Bela Stoyan";
    email = "nix@be7a.de";

    github = "0xbe7a";
    githubId = 6232980;
    keys = [{
      fingerprint = "2536 9E86 1AA5 9EB7 4C47  B138 6510 870A 77F4 9A99";
    }];
  };
  _0xC45 = {
    name = "Jason Vigil";
    email = "jason@0xc45.com";

    matrix = "@oxc45:matrix.org";
    github = "0xC45";
    githubId = 56617252;
  };
  _0xd61 = {
    name = "Daniel Glinka";
    email = "dgl@degit.co";

    github = "0xd61";
    githubId = 8351869;
  };
  _1000101 = {
    name = "Jan Hrnko";
    email = "b1000101@pm.me";

    github = "1000101";
    githubId = 791309;
  };
  _1000teslas = {
    name = "Kevin Tran";
    email = "47207223+1000teslas@users.noreply.github.com";

    github = "1000teslas";
    githubId = 47207223;
  };
  _13r0ck = {
    name = "Brock Szuszczewicz";
    email = "bnr@tuta.io";

    github = "13r0ck";
    githubId = 58987761;
  };
  _2gn = {
    name = "Hiram Tanner";
    email = "101851090+2gn@users.noreply.github.com";

    github = "2gn";
    githubId = 101851090;
  };
  _360ied = {
    name = "Brian Zhu";
    email = "therealbarryplayer@gmail.com";

    github = "360ied";
    githubId = 19516527;
  };
  _3699n = {
    name = "Nicholas von Klitzing";
    email = "nicholas@nvk.pm";

    github = "3699n";
    githubId = 7414843;
  };
  _3JlOy-PYCCKUi = {
    name = "3JlOy-PYCCKUi";
    email = "3jl0y_pycckui@riseup.net";

    github = "3JlOy-PYCCKUi";
    githubId = 46464602;
  };
  _3noch = {
    name = "Elliot Cameron";
    email = "eacameron@gmail.com";

    github = "3noch";
    githubId = 882455;
  };
  _414owen = {
    name = "Owen Shepherd";
    email = "owen@owen.cafe";

    github = "414owen";
    githubId = 1714287;
  };
  _4825764518 = {
    name = "Kenzie";
    email = "4825764518@purelymail.com";

    matrix = "@kenzie:matrix.kenzi.dev";
    github = "4825764518";
    githubId = 100122841;
    keys = [{
      fingerprint = "D292 365E 3C46 A5AA 75EE  B30B 78DB 7EDE 3540 794B";
    }];
  };
  _6AA4FD = {
    name = "Quinn Bohner";
    email = "f6442954@gmail.com";

    github = "6AA4FD";
    githubId = 12578560;
  };
  a-kenji = {
    name = "Alexander Kenji Berthold";
    email = "aks.kenji@protonmail.com";

    github = "a-kenji";
    githubId = 65275785;
  };
  a1russell = {
    name = "Adam Russell";
    email = "adamlr6+pub@gmail.com";

    github = "a1russell";
    githubId = 241628;
  };
  aacebedo = {
    name = "Alexandre Acebedo";
    email = "alexandre@acebedo.fr";

    github = "aacebedo";
    githubId = 1217680;
  };
  aadibajpai = {
    name = "Aadi Bajpai";
    email = "hello@aadibajpai.com";

    github = "aadibajpai";
    githubId = 27063113;
  };
  aanderse = {
    name = "Aaron Andersen";
    email = "aaron@fosslib.net";

    matrix = "@aanderse:nixos.dev";
    github = "aanderse";
    githubId = 7755101;
  };
  aaqaishtyaq = {
    name = "Aaqa Ishtyaq";
    email = "aaqaishtyaq@gmail.com";

    github = "aaqaishtyaq";
    githubId = 22131756;
  };
  aaronjanse = {
    name = "Aaron Janse";
    email = "aaron@ajanse.me";

    matrix = "@aaronjanse:matrix.org";
    github = "aaronjanse";
    githubId = 16829510;
  };
  aaronjheng = {
    name = "Aaron Jheng";
    email = "wentworth@outlook.com";

    github = "aaronjheng";
    githubId = 806876;
  };
  aaronschif = {
    name = "Aaron Schif";
    email = "aaronschif@gmail.com";

    github = "aaronschif";
    githubId = 2258953;
  };
  aaschmid = {
    name = "Andreas Schmid";
    email = "service@aaschmid.de";

    github = "aaschmid";
    githubId = 567653;
  };
  abaldeau = {
    name = "Andreas Baldeau";
    email = "andreas@baldeau.net";

    github = "baldo";
    githubId = 178750;
  };
  abathur = {
    name = "Travis A. Everett";
    email = "travis.a.everett+nixpkgs@gmail.com";

    github = "abathur";
    githubId = 2548365;
  };
  abbe = {
    name = "Ashish SHUKLA";
    email = "ashish.is@lostca.se";

    matrix = "@abbe:badti.me";
    github = "wahjava";
    githubId = 2255192;
    keys = [{
      fingerprint = "F682 CDCC 39DC 0FEA E116  20B6 C746 CFA9 E74F A4B0";
    }];
  };
  abbradar = {
    name = "Nikolay Amiantov";
    email = "ab@fmap.me";

    github = "abbradar";
    githubId = 1174810;
  };
  abhi18av = {
    name = "Abhinav Sharma";
    email = "abhi18av@gmail.com";

    github = "abhi18av";
    githubId = 12799326;
  };
  abigailbuccaneer = {
    name = "Abigail Bunyan";
    email = "abigailbuccaneer@gmail.com";

    github = "AbigailBuccaneer";
    githubId = 908758;
  };
  aborsu = {
    name = "Augustin Borsu";
    email = "a.borsu@gmail.com";

    github = "aborsu";
    githubId = 5033617;
  };
  aboseley = {
    name = "Adam Boseley";
    email = "adam.boseley@gmail.com";

    github = "aboseley";
    githubId = 13504599;
  };
  abuibrahim = {
    name = "Ruslan Babayev";
    email = "ruslan@babayev.com";

    github = "abuibrahim";
    githubId = 2321000;
  };
  acairncross = {
    name = "Aiken Cairncross";
    email = "acairncross@gmail.com";

    github = "acairncross";
    githubId = 1517066;
  };
  aciceri = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";

    github = "aciceri";
    githubId = 2318843;
  };
  acowley = {
    name = "Anthony Cowley";
    email = "acowley@gmail.com";

    github = "acowley";
    githubId = 124545;
  };
  adamcstephens = {
    name = "Adam C. Stephens";
    email = "happy.plan4249@valkor.net";

    matrix = "@adam:valkor.net";
    github = "adamcstephens";
    githubId = 2071575;
  };
  adamlwgriffiths = {
    name = "Adam Griffiths";
    email = "adam.lw.griffiths@gmail.com";

    github = "adamlwgriffiths";
    githubId = 1239156;
  };
  adamt = {
    name = "Adam Tulinius";
    email = "mail@adamtulinius.dk";

    github = "adamtulinius";
    githubId = 749381;
  };
  addict3d = {
    name = "Nick Bathum";
    email = "nickbathum@gmail.com";

    matrix = "@nbathum:matrix.org";
    github = "addict3d";
    githubId = 49227;
  };
  adelbertc = {
    name = "Adelbert Chang";
    email = "adelbertc@gmail.com";

    github = "adelbertc";
    githubId = 1332980;
  };
  adev = {
    name = "Adrien Devresse";
    email = "adev@adev.name";

    github = "adevress";
    githubId = 1773511;
  };
  adisbladis = {
    name = "Adam Hose";
    email = "adisbladis@gmail.com";

    matrix = "@adis:blad.is";
    github = "adisbladis";
    githubId = 63286;
  };
  adjacentresearch = {
    name = "0xperp";
    email = "nate@adjacentresearch.xyz";

    github = "0xperp";
    githubId = 96147421;
  };
  Adjective-Object = {
    name = "Maxwell Huang-Hobbs";
    email = "mhuan13@gmail.com";

    github = "Adjective-Object";
    githubId = 1174858;
  };
  adnelson = {
    name = "Allen Nelson";
    email = "ithinkican@gmail.com";

    github = "adnelson";
    githubId = 5091511;
  };
  adolfogc = {
    name = "Adolfo E. García Castro";
    email = "adolfo.garcia.cr@gmail.com";

    github = "adolfogc";
    githubId = 1250775;
  };
  AdsonCicilioti = {
    name = "Adson Cicilioti";
    email = "adson.cicilioti@live.com";

    github = "AdsonCicilioti";
    githubId = 6278398;
  };
  adsr = {
    name = "Adam Saponara";
    email = "as@php.net";

    github = "adsr";
    githubId = 315003;
  };
  aerialx = {
    name = "Aaron Lindsay";
    email = "aaron+nixos@aaronlindsay.com";

    github = "AerialX";
    githubId = 117295;
  };
  aespinosa = {
    name = "Allan Espinosa";
    email = "allan.espinosa@outlook.com";

    github = "aespinosa";
    githubId = 58771;
  };
  aethelz = {
    name = "Eugene";
    email = "aethelz@protonmail.com";

    github = "eugenezastrogin";
    githubId = 10677343;
  };
  afh = {
    name = "Alexis Hildebrandt";
    email = "surryhill+nix@gmail.com";

    github = "afh";
    githubId = 16507;
  };
  aflatter = {
    name = "Alexander Flatter";
    email = "flatter@fastmail.fm";

    github = "aflatter";
    githubId = 168;
  };
  afldcr = {
    name = "James Alexander Feldman-Crough";
    email = "alex@fldcr.com";

    github = "afldcr";
    githubId = 335271;
  };
  afontain = {
    name = "Antoine Fontaine";
    email = "antoine.fontaine@epfl.ch";

    github = "necessarily-equal";
    githubId = 59283660;
  };
  aforemny = {
    name = "Alexander Foremny";
    email = "aforemny@posteo.de";

    github = "aforemny";
    githubId = 610962;
  };
  afranchuk = {
    name = "Alex Franchuk";
    email = "alex.franchuk@gmail.com";

    github = "afranchuk";
    githubId = 4296804;
  };
  agbrooks = {
    name = "Andrew Brooks";
    email = "andrewgrantbrooks@gmail.com";

    github = "agbrooks";
    githubId = 19290901;
  };
  aherrmann = {
    name = "Andreas Herrmann";
    email = "andreash87@gmx.ch";

    github = "aherrmann";
    githubId = 732652;
  };
  ahrzb = {
    name = "AmirHossein Roozbahani";
    email = "ahrzb5@gmail.com";

    github = "ahrzb";
    githubId = 5220438;
  };
  ahuzik = {
    name = "Alesya Huzik";
    email = "ah1990au@gmail.com";

    github = "alesya-h";
    githubId = 209175;
  };
  aidalgol = {
    name = "Aidan Gauland";
    email = "aidalgol+nixpkgs@fastmail.net";

    github = "aidalgol";
    githubId = 2313201;
  };
  aij = {
    name = "Ivan Jager";
    email = "aij+git@mrph.org";

    github = "aij";
    githubId = 4732885;
  };
  aiotter = {
    name = "Yuto Oguchi";
    email = "git@aiotter.com";

    github = "aiotter";
    githubId = 37664775;
  };
  airwoodix = {
    name = "Etienne Wodey";
    email = "airwoodix@posteo.me";

    github = "airwoodix";
    githubId = 44871469;
  };
  ajgrf = {
    name = "Alex Griffin";
    email = "a@ajgrf.com";

    github = "ajgrf";
    githubId = 10733175;
  };
  ajs124 = {
    name = "Andreas Schrägle";
    email = "nix@ajs124.de";

    matrix = "@andreas.schraegle:helsinki-systems.de";
    github = "ajs124";
    githubId = 1229027;
  };
  ak = {
    name = "Alexander Kjeldaas";
    email = "ak@formalprivacy.com";

    github = "alexanderkjeldaas";
    githubId = 339369;
  };
  akamaus = {
    name = "Dmitry Vyal";
    email = "dmitryvyal@gmail.com";

    github = "akamaus";
    githubId = 58955;
  };
  akavel = {
    name = "Mateusz Czapliński";
    email = "czapkofan@gmail.com";

    github = "akavel";
    githubId = 273837;
  };
  akaWolf = {
    name = "Artjom Vejsel";
    email = "akawolf0@gmail.com";

    github = "akaWolf";
    githubId = 5836586;
  };
  akc = {
    name = "Anders Claesson";
    email = "akc@akc.is";

    github = "akc";
    githubId = 1318982;
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
    name = "Alexander Krupenkin ";
    email = "mail@akru.me";

    github = "akru";
    githubId = 786394;
  };
  akshgpt7 = {
    name = "Aksh Gupta";
    email = "akshgpt7@gmail.com";

    github = "akshgpt7";
    githubId = 20405311;
  };
  alapshin = {
    name = "Andrei Lapshin";
    email = "alapshin@fastmail.com";

    github = "alapshin";
    githubId = 321946;
  };
  albakham = {
    name = "Titouan Biteau";
    email = "dev@geber.ga";

    github = "albakham";
    githubId = 43479487;
  };
  alekseysidorov = {
    name = "Aleksey Sidorov";
    email = "sauron1987@gmail.com";

    github = "alekseysidorov";
    githubId = 83360;
  };
  alerque = {
    name = "Caleb Maclennan";
    email = "caleb@alerque.com";

    github = "alerque";
    githubId = 173595;
  };
  ALEX11BR = {
    name = "Popa Ioan Alexandru";
    email = "alexioanpopa11@gmail.com";

    github = "ALEX11BR";
    githubId = 49609151;
  };
  alexarice = {
    name = "Alex Rice";
    email = "alexrice999@hotmail.co.uk";

    github = "alexarice";
    githubId = 17208985;
  };
  alexbakker = {
    name = "Alexander Bakker";
    email = "ab@alexbakker.me";

    github = "alexbakker";
    githubId = 2387841;
  };
  alexbiehl = {
    name = "Alex Biehl";
    email = "alexbiehl@gmail.com";

    github = "alexbiehl";
    githubId = 1876617;
  };
  alexchapman = {
    name = "Alex Chapman";
    email = "alex@farfromthere.net";

    github = "AJChapman";
    githubId = 8316672;
  };
  alexeyre = {
    name = "Alex Eyre";
    email = "A.Eyre@sms.ed.ac.uk";

    github = "alexeyre";
    githubId = 38869148;
  };
  alexfmpe = {
    name = "Alexandre Esteves";
    email = "alexandre.fmp.esteves@gmail.com";

    github = "alexfmpe";
    githubId = 2335822;
  };
  alexnortung = {
    name = "alexnortung";
    email = "alex_nortung@live.dk";

    github = "Alexnortung";
    githubId = 1552267;
  };
  alexshpilkin = {
    name = "Alexander Shpilkin";
    email = "ashpilkin@gmail.com";

    matrix = "@alexshpilkin:matrix.org";
    github = "alexshpilkin";
    githubId = 1010468;
    keys = [{
      fingerprint = "B595 D74D 6615 C010 469F  5A13 73E9 AA11 4B3A 894B";
    }];
  };
  alexvorobiev = {
    name = "Alex Vorobiev";
    email = "alexander.vorobiev@gmail.com";

    github = "alexvorobiev";
    githubId = 782180;
  };
  alexwinter = {
    name = "Alex Winter";
    email = "git@alexwinter.net";

    github = "lxwntr";
    githubId = 50754358;
  };
  algram = {
    name = "Alias Gram";
    email = "aliasgram@gmail.com";

    github = "Algram";
    githubId = 5053729;
  };
  alibabzo = {
    name = "Alistair Bill";
    email = "alistair.bill@gmail.com";

    github = "alistairbill";
    githubId = 2822871;
  };
  alirezameskin = {
    name = "Alireza Meskin";
    email = "alireza.meskin@gmail.com";

    github = "alirezameskin";
    githubId = 36147;
  };
  alkasm = {
    name = "Alexander Reynolds";
    email = "alexreynolds00@gmail.com";

    github = "alkasm";
    githubId = 9651002;
  };
  alkeryn = {
    name = "Pierre-Louis Braun";
    email = "plbraundev@gmail.com";

    github = "alkeryn";
    githubId = 11599075;
  };
  allonsy = {
    name = "Alec Snyder";
    email = "linuxbash8@gmail.com";

    github = "allonsy";
    githubId = 5892756;
  };
  almac = {
    name = "Alma Cemerlic";
    email = "alma.cemerlic@gmail.com";

    github = "a1mac";
    githubId = 60479013;
  };
  alternateved = {
    name = "Tomasz Hołubowicz";
    email = "alternateved@pm.me";

    github = "alternateved";
    githubId = 45176912;
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
  alunduil = {
    name = "Alex Brandt";
    email = "alunduil@gmail.com";

    github = "alunduil";
    githubId = 169249;
  };
  alva = {
    name = "Alva";
    email = "alva@skogen.is";

    github = "illfygli";
    githubId = 42881386;
    keys = [{
      fingerprint = "B422 CFB1 C9EF 73F7 E1E2 698D F53E 3233 42F7 A6D3A";
    }];
  };
  alyaeanyx = {
    name = "Alexandra Hollmeier";
    email = "alexandra.hollmeier@mailbox.org";

    github = "alyaeanyx";
    githubId = 74795488;
    keys = [{
      fingerprint = "1F73 8879 5E5A 3DFC E2B3 FA32 87D1 AADC D25B 8DEE";
    }];
  };
  amanjeev = {
    name = "Amanjeev Sethi";
    email = "aj@amanjeev.com";

    github = "amanjeev";
    githubId = 160476;
  };
  amar1729 = {
    name = "Amar Paul";
    email = "amar.paul16@gmail.com";

    github = "Amar1729";
    githubId = 15623522;
  };
  amarshall = {
    name = "Andrew Marshall";
    email = "andrew@johnandrewmarshall.com";

    github = "amarshall";
    githubId = 153175;
  };
  ambroisie = {
    name = "Bruno BELANYI";
    email = "bruno.nixpkgs@belanyi.fr";

    github = "ambroisie";
    githubId = 12465195;
  };
  ambrop72 = {
    name = "Ambroz Bizjak";
    email = "ambrop7@gmail.com";

    github = "ambrop72";
    githubId = 2626481;
  };
  ameer = {
    name = "Ameer Taweel";
    email = "ameertaweel2002@gmail.com";

    github = "AmeerTaweel";
    githubId = 20538273;
  };
  amesgen = {
    name = "Alexander Esgen";
    email = "amesgen@amesgen.de";

    matrix = "@amesgen:amesgen.de";
    github = "amesgen";
    githubId = 15369874;
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
    name = "amfl";
    email = "amfl@none.none";

    github = "amfl";
    githubId = 382798;
  };
  amiddelk = {
    name = "Arie Middelkoop";
    email = "amiddelk@gmail.com";

    github = "amiddelk";
    githubId = 1358320;
  };
  amiloradovsky = {
    name = "Andrew Miloradovsky";
    email = "miloradovsky@gmail.com";

    github = "amiloradovsky";
    githubId = 20530052;
  };
  aminechikhaoui = {
    name = "Amine Chikhaoui";
    email = "amine.chikhaoui91@gmail.com";

    github = "AmineChikhaoui";
    githubId = 5149377;
  };
  amorsillo = {
    name = "Andrew Morsillo";
    email = "andrew.morsillo@gmail.com";

    github = "evelant";
    githubId = 858965;
  };
  an-empty-string = {
    name = "Tris Emmy Wilson";
    email = "tris@tris.fyi";

    github = "an-empty-string";
    githubId = 681716;
  };
  AnatolyPopov = {
    name = "Anatolii Popov";
    email = "aipopov@live.ru";

    github = "AnatolyPopov";
    githubId = 2312534;
  };
  andehen = {
    name = "Anders Asheim Hennum";
    email = "git@andehen.net";

    github = "andehen";
    githubId = 754494;
  };
  andersk = {
    name = "Anders Kaseorg";
    email = "andersk@mit.edu";

    github = "andersk";
    githubId = 26471;
  };
  anderslundstedt = {
    name = "Anders Lundstedt";
    email = "git@anderslundstedt.se";

    github = "anderslundstedt";
    githubId = 4514101;
  };
  AndersonTorres = {
    name = "Anderson Torres";
    email = "torres.anderson.85@protonmail.com";

    matrix = "@anderson_torres:matrix.org";
    github = "AndersonTorres";
    githubId = 5954806;
  };
  anderspapitto = {
    name = "Anders Papitto";
    email = "anderspapitto@gmail.com";

    github = "anderspapitto";
    githubId = 1388690;
  };
  andir = {
    name = "Andreas Rammhold";
    email = "andreas@rammhold.de";

    github = "andir";
    githubId = 638836;
  };
  andreasfelix = {
    name = "Felix Andreas";
    email = "fandreas@physik.hu-berlin.de";

    github = "andreasfelix";
    githubId = 24651767;
  };
  andres = {
    name = "Andres Loeh";
    email = "ksnixos@andres-loeh.de";

    github = "kosmikus";
    githubId = 293191;
  };
  andresilva = {
    name = "André Silva";
    email = "andre.beat@gmail.com";

    github = "andresilva";
    githubId = 123550;
  };
  andrestylianos = {
    name = "Andre S. Ramos";
    email = "andre.stylianos@gmail.com";

    github = "andrestylianos";
    githubId = 7112447;
  };
  andrevmatos = {
    name = "André V L Matos";
    email = "andrevmatos@gmail.com";

    github = "andrevmatos";
    githubId = 587021;
  };
  andrew-d = {
    name = "Andrew Dunham";
    email = "andrew@du.nham.ca";

    github = "andrew-d";
    githubId = 1079173;
  };
  andrewchambers = {
    name = "Andrew Chambers";
    email = "ac@acha.ninja";

    github = "andrewchambers";
    githubId = 962885;
  };
  andrewrk = {
    name = "Andrew Kelley";
    email = "superjoe30@gmail.com";

    github = "andrewrk";
    githubId = 106511;
  };
  andsild = {
    name = "Anders Sildnes";
    email = "andsild@gmail.com";

    github = "andsild";
    githubId = 3808928;
  };
  andys8 = {
    name = "Andy";
    email = "andys8@users.noreply.github.com";

    github = "andys8";
    githubId = 13085980;
  };
  aneeshusa = {
    name = "Aneesh Agrawal";
    email = "aneeshusa@gmail.com";

    github = "aneeshusa";
    githubId = 2085567;
  };
  angristan = {
    name = "Stanislas Lange";
    email = "angristan@pm.me";

    github = "angristan";
    githubId = 11699655;
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
    name = "Vo Anh Duy";
    email = "vo@anhduy.io";

    github = "voanhduy1512";
    githubId = 1771266;
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
    name = "Anirrudh Krishnan";
    email = "anik597@gmail.com";

    github = "anirrudh";
    githubId = 6091755;
  };
  ankhers = {
    name = "Justin Wood";
    email = "me@ankhers.dev";

    github = "ankhers";
    githubId = 750786;
  };
  anmonteiro = {
    name = "Antonio Nuno Monteiro";
    email = "anmonteiro@gmail.com";

    github = "anmonteiro";
    githubId = 661909;
  };
  anna328p = {
    name = "Anna";
    email = "anna328p@gmail.com";

    github = "anna328p";
    githubId = 9790772;
  };
  annaaurora = {
    name = "Anna Aurora";
    email = "anna@annaaurora.eu";

    matrix = "@papojari:artemislena.eu";
    github = "auroraanna";
    githubId = 81317317;
  };
  anoa = {
    name = "Andrew Morgan";
    email = "andrew@amorgan.xyz";

    matrix = "@andrewm:amorgan.xyz";
    github = "anoadragon453";
    githubId = 1342360;
  };
  anpryl = {
    name = "Anatolii Prylutskyi";
    email = "anpryl@gmail.com";

    github = "anpryl";
    githubId = 5327697;
  };
  anselmschueler = {
    name = "Anselm Schüler";
    email = "mail@anselmschueler.com";

    matrix = "@schuelermine:matrix.org";
    github = "schuelermine";
    githubId = 48802534;
  };
  anthonyroussel = {
    name = "Anthony Roussel";
    email = "anthony@roussel.dev";

    github = "anthonyroussel";
    githubId = 220084;
    keys = [{
      fingerprint = "472D 368A F107 F443 F3A5  C712 9DC4 987B 1A55 E75E";
    }];
  };
  antoinerg = {
    name = "Antoine Roy-Gobeil";
    email = "roygobeil.antoine@gmail.com";

    github = "antoinerg";
    githubId = 301546;
  };
  anton-dessiatov = {
    name = "Anton Desyatov";
    email = "anton.dessiatov@gmail.com";

    github = "anton-dessiatov";
    githubId = 2873280;
  };
  Anton-Latukha = {
    name = "Anton Latukha";
    email = "anton.latuka+nixpkgs@gmail.com";

    github = "Anton-Latukha";
    githubId = 20933385;
  };
  antono = {
    name = "Antono Vasiljev";
    email = "self@antono.info";

    github = "antono";
    githubId = 7622;
  };
  antonxy = {
    name = "Anton Schirg";
    email = "anton.schirg@posteo.de";

    github = "antonxy";
    githubId = 4194320;
  };
  apeschar = {
    name = "Albert Peschar";
    email = "albert@peschar.net";

    github = "apeschar";
    githubId = 122977;
  };
  apeyroux = {
    name = "Alexandre Peyroux";
    email = "alex@px.io";

    github = "apeyroux";
    githubId = 1078530;
  };
  applePrincess = {
    name = "Lein Matsumaru";
    email = "appleprincess@appleprincess.io";

    github = "applePrincess";
    githubId = 17154507;
    keys = [{
      fingerprint = "BF8B F725 DA30 E53E 7F11  4ED8 AAA5 0652 F047 9205";
    }];
  };
  apraga = {
    name = "Alexis Praga";
    email = "alexis.praga@proton.me";

    github = "apraga";
    githubId = 914687;
  };
  ar1a = {
    name = "Aria Edmonds";
    email = "aria@ar1as.space";

    github = "ar1a";
    githubId = 8436007;
  };
  arcadio = {
    name = "Arcadio Rubio García";
    email = "arc@well.ox.ac.uk";

    github = "arcadio";
    githubId = 56009;
  };
  archer-65 = {
    name = "Mario Liguori";
    email = "mario.liguori.056@gmail.com";

    github = "archer-65";
    githubId = 76066109;
  };
  archseer = {
    name = "Blaž Hrastnik";
    email = "blaz@mxxn.io";

    github = "archseer";
    githubId = 1372918;
  };
  arcnmx = {
    name = "arcnmx";
    email = "arcnmx@users.noreply.github.com";

    github = "arcnmx";
    githubId = 13426784;
  };
  arcticlimer = {
    name = "Vinícius Müller";
    email = "vinigm.nho@gmail.com";

    github = "viniciusmuller";
    githubId = 59743220;
  };
  ardumont = {
    name = "Antoine R. Dumont";
    email = "eniotna.t@gmail.com";

    github = "ardumont";
    githubId = 718812;
  };
  arezvov = {
    name = "Alexander Rezvov";
    email = "alex@rezvov.ru";

    github = "arezvov";
    githubId = 58516559;
  };
  arianvp = {
    name = "Arian van Putten";
    email = "arian.vanputten@gmail.com";

    github = "arianvp";
    githubId = 628387;
  };
  arikgrahl = {
    name = "Arik Grahl";
    email = "mail@arik-grahl.de";

    github = "arikgrahl";
    githubId = 8049011;
  };
  aristid = {
    name = "Aristid Breitkreuz";
    email = "aristidb@gmail.com";

    github = "aristidb";
    githubId = 30712;
  };
  ariutta = {
    name = "Anders Riutta";
    email = "anders.riutta@gmail.com";

    github = "ariutta";
    githubId = 1296771;
  };
  arjan-s = {
    name = "Arjan Schrijver";
    email = "github@anymore.nl";

    github = "arjan-s";
    githubId = 10400299;
  };
  arjix = {
    name = "arjix";
    email = "arjix@protonmail.com";

    github = "arjix";
    githubId = 62168569;
  };
  arkivm = {
    name = "Vikram Narayanan";
    email = "vikram186@gmail.com";

    github = "arkivm";
    githubId = 1118815;
  };
  armeenm = {
    name = "Armeen Mahdian";
    email = "mahdianarmeen@gmail.com";

    github = "armeenm";
    githubId = 29145250;
  };
  armijnhemel = {
    name = "Armijn Hemel";
    email = "armijn@tjaldur.nl";

    github = "armijnhemel";
    githubId = 10587952;
  };
  arnarg = {
    name = "Arnar Ingason";
    email = "arnarg@fastmail.com";

    github = "arnarg";
    githubId = 1291396;
  };
  arnoldfarkas = {
    name = "Arnold Farkas";
    email = "arnold.farkas@gmail.com";

    github = "arnoldfarkas";
    githubId = 59696216;
  };
  arnoutkroeze = {
    name = "Arnout Kroeze";
    email = "nixpkgs@arnoutkroeze.nl";

    github = "ArnoutKroeze";
    githubId = 37151054;
  };
  arobyn = {
    name = "Alexei Robyn";
    email = "shados@shados.net";

    github = "Shados";
    githubId = 338268;
  };
  artemist = {
    name = "Artemis Tosini";
    email = "me@artem.ist";

    github = "artemist";
    githubId = 1226638;
    keys = [{
      fingerprint = "3D2B B230 F9FA F0C5 1832  46DD 4FDC 96F1 61E7 BA8A";
    }];
  };
  arthur = {
    name = "Arthur Lee";
    email = "me@arthur.li";

    github = "arthurl";
    githubId = 3965744;
  };
  arthurteisseire = {
    name = "Arthur Teisseire";
    email = "arthurteisseire33@gmail.com";

    github = "arthurteisseire";
    githubId = 37193992;
  };
  artturin = {
    name = "Artturi N";
    email = "artturin@artturin.com";

    matrix = "@artturin:matrix.org";
    github = "Artturin";
    githubId = 56650223;
  };
  arturcygan = {
    name = "Artur Cygan";
    email = "arczicygan@gmail.com";

    github = "arcz";
    githubId = 4679721;
  };
  artuuge = {
    name = "Artur E. Ruuge";
    email = "artuuge@gmail.com";

    github = "artuuge";
    githubId = 10285250;
  };
  asbachb = {
    name = "Benjamin Asbach";
    email = "asbachb-nixpkgs-5c2a@impl.it";

    matrix = "@asbachb:matrix.org";
    github = "asbachb";
    githubId = 1482768;
  };
  ashalkhakov = {
    name = "Artyom Shalkhakov";
    email = "artyom.shalkhakov@gmail.com";

    github = "ashalkhakov";
    githubId = 1270502;
  };
  ashgillman = {
    name = "Ashley Gillman";
    email = "gillmanash@gmail.com";

    github = "ashgillman";
    githubId = 816777;
  };
  ashkitten = {
    name = "ash lea";
    email = "ashlea@protonmail.com";

    github = "ashkitten";
    githubId = 9281956;
  };
  ashley = {
    name = "Ashley Chiara";
    email = "ashley@kira64.xyz";

    github = "kira64xyz";
    githubId = 84152630;
  };
  aske = {
    name = "Kirill Boltaev";
    email = "aske@fmap.me";

    github = "aske";
    githubId = 869771;
  };
  asppsa = {
    name = "Alastair Pharo";
    email = "asppsa@gmail.com";

    github = "asppsa";
    githubId = 453170;
  };
  astro = {
    name = "Astro";
    email = "astro@spaceboyz.net";

    github = "astro";
    githubId = 12923;
  };
  astrobeastie = {
    name = "Vincent Fischer";
    email = "fischervincent98@gmail.com";

    github = "astrobeastie";
    githubId = 26362368;
    keys = [{
      fingerprint = "BF47 81E1 F304 1ADF 18CE  C401 DE16 C7D1 536D A72F";
    }];
  };
  astsmtl = {
    name = "Alexander Tsamutali";
    email = "astsmtl@yandex.ru";

    github = "astsmtl";
    githubId = 2093941;
  };
  asymmetric = {
    name = "Lorenzo Manacorda";
    email = "lorenzo@mailbox.org";

    github = "asymmetric";
    githubId = 101816;
  };
  aszlig = {
    name = "aszlig";
    email = "aszlig@nix.build";

    github = "aszlig";
    githubId = 192147;
    keys = [{
      fingerprint = "DD52 6BC7 767D BA28 16C0 95E5 6840 89CE 67EB B691";
    }];
  };
  ataraxiasjel = {
    name = "Dmitriy";
    email = "nix@ataraxiadev.com";

    github = "AtaraxiaSjel";
    githubId = 5314145;
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
    name = "Troels Henriksen";
    email = "athas@sigkill.dk";

    github = "athas";
    githubId = 55833;
  };
  atila = {
    name = "Átila Saraiva";
    email = "atilasaraiva@gmail.com";

    github = "AtilaSaraiva";
    githubId = 29521461;
  };
  atkinschang = {
    name = "Atkins Chang";
    email = "atkinschang+nixpkgs@gmail.com";

    github = "AtkinsChang";
    githubId = 5193600;
  };
  atnnn = {
    name = "Etienne Laurin";
    email = "etienne@atnnn.com";

    github = "AtnNn";
    githubId = 706854;
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
    name = "Jonathan Glines";
    email = "auntieNeo@gmail.com";

    github = "auntieNeo";
    githubId = 574938;
  };
  austinbutler = {
    name = "Austin Butler";
    email = "austinabutler@gmail.com";

    github = "austinbutler";
    githubId = 354741;
  };
  autophagy = {
    name = "Mika Naylor";
    email = "mail@autophagy.io";

    github = "autophagy";
    githubId = 12958979;
  };
  avaq = {
    name = "Aldwin Vlasblom";
    email = "nixpkgs@account.avaq.it";

    github = "Avaq";
    githubId = 1217745;
  };
  aveltras = {
    name = "Romain Viallard";
    email = "romain.viallard@outlook.fr";

    github = "aveltras";
    githubId = 790607;
  };
  averelld = {
    name = "averelld";
    email = "averell+nixos@rxd4.com";

    github = "averelld";
    githubId = 687218;
  };
  avery = {
    name = "Avery Lychee";
    email = "averyl+nixos@protonmail.com";

    github = "AveryLychee";
    githubId = 9147625;
  };
  avh4 = {
    name = "Aaron VonderHaar";
    email = "gruen0aermel@gmail.com";

    github = "avh4";
    githubId = 1222;
  };
  avitex = {
    name = "avitex";
    email = "theavitex@gmail.com";

    github = "avitex";
    githubId = 5110816;
    keys = [{
      fingerprint = "271E 136C 178E 06FA EA4E  B854 8B36 6C44 3CAB E942";
    }];
  };
  avnik = {
    name = "Alexander V. Nikolaev";
    email = "avn@avnik.info";

    github = "avnik";
    githubId = 153538;
  };
  aw = {
    name = "Andreas Wiese";
    email = "aw-nixos@meterriblecrew.net";

    github = "herrwiese";
    githubId = 206242;
  };
  ayazhafiz = {
    name = "Ayaz Hafiz";
    email = "ayaz.hafiz.1@gmail.com";

    github = "hafiz";
    githubId = 262763;
  };
  aycanirican = {
    name = "Aycan iRiCAN";
    email = "iricanaycan@gmail.com";

    github = "aycanirican";
    githubId = 135230;
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
  azuwis = {
    name = "Zhong Jianxin";
    email = "azuwis@gmail.com";

    github = "azuwis";
    githubId = 9315;
  };
  b4dm4n = {
    name = "Fabian Möller";
    email = "fabianm88@gmail.com";

    github = "B4dM4n";
    githubId = 448169;
    keys = [{
      fingerprint = "6309 E212 29D4 DA30 AF24  BDED 754B 5C09 63C4 2C50";
    }];
  };
  babariviere = {
    name = "Bastien Rivière";
    email = "me@babariviere.com";

    github = "babariviere";
    githubId = 12128029;
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
    name = "Pascal Bach";
    email = "pascal.bach@nextrem.ch";

    matrix = "@bachp:matrix.org";
    github = "bachp";
    githubId = 333807;
  };
  backuitist = {
    name = "Bruno Bieth";
    email = "biethb@gmail.com";

    github = "backuitist";
    githubId = 1017537;
  };
  badmutex = {
    name = "Badi' Abdul-Wahid";
    email = "github@badi.sh";

    github = "badmutex";
    githubId = 35324;
  };
  baduhai = {
    name = "William";
    email = "baduhai@pm.me";

    github = "baduhai";
    githubId = 31864305;
  };
  baitinq = {
    name = "Baitinq";
    email = "manuelpalenzuelamerino@gmail.com";

    github = "Baitinq";
    githubId = 30861839;
  };
  balodja = {
    name = "Vladimir Korolev";
    email = "balodja@gmail.com";

    github = "balodja";
    githubId = 294444;
  };
  baloo = {
    name = "Arthur Gautier";
    email = "nixpkgs@superbaloo.net";

    github = "baloo";
    githubId = 59060;
  };
  balsoft = {
    name = "Alexander Bantyev";
    email = "balsoft75@gmail.com";

    github = "balsoft";
    githubId = 18467667;
  };
  bandresen = {
    name = "Benjamin Andresen";
    email = "bandresen@gmail.com";

    github = "bennyandresen";
    githubId = 80325;
  };
  baracoder = {
    name = "Herman Fries";
    email = "baracoder@googlemail.com";

    github = "baracoder";
    githubId = 127523;
  };
  BarinovMaxim = {
    name = "Barinov Maxim";
    email = "barinov274@gmail.com";

    github = "barinov274";
    githubId = 54442153;
  };
  barrucadu = {
    name = "Michael Walker";
    email = "mike@barrucadu.co.uk";

    github = "barrucadu";
    githubId = 75235;
  };
  bartsch = {
    name = "Daniel Martin";
    email = "consume.noise@gmail.com";

    github = "bartsch";
    githubId = 3390885;
  };
  bartuka = {
    name = "Wanderson Ferreira";
    email = "wand@hey.com";

    github = "wandersoncferreira";
    githubId = 17708295;
    keys = [{
      fingerprint = "A3E1 C409 B705 50B3 BF41  492B 5684 0A61 4DBE 37AE";
    }];
  };
  basvandijk = {
    name = "Bas van Dijk";
    email = "v.dijk.bas@gmail.com";

    github = "basvandijk";
    githubId = 576355;
  };
  BattleCh1cken = {
    name = "Felix Hass";
    email = "BattleCh1cken@larkov.de";

    github = "BattleCh1cken";
    githubId = 75806385;
  };
  Baughn = {
    name = "Svein Ove Aas";
    email = "sveina@gmail.com";

    github = "Baughn";
    githubId = 45811;
  };
  bb010g = {
    name = "Brayden Banks";
    email = "me@bb010g.com";

    matrix = "@bb010g:matrix.org";
    github = "bb010g";
    githubId = 340132;
  };
  bb2020 = {
    name = "Tunc Uzlu";
    email = "bb2020@users.noreply.github.com";

    github = "bb2020";
    githubId = 19290397;
  };
  bbarker = {
    name = "Brandon Elam Barker";
    email = "brandon.barker@gmail.com";

    github = "bbarker";
    githubId = 916366;
  };
  bbenne10 = {
    name = "Bryan Bennett";
    email = "Bryan.Bennett@protonmail.com";

    matrix = "@bryan.bennett:matrix.org";
    github = "bbenne10";
    githubId = 687376;
    keys = [{
      fingerprint = "41EA 00B4 00F9 6970 1CB2  D3AF EF90 E3E9 8B8F 5C0B";
    }];
  };
  bbenno = {
    name = "Benno Bielmeier";
    email = "nix@bbenno.com";

    github = "bbenno";
    githubId = 32938211;
  };
  bbigras = {
    name = "Bruno Bigras";
    email = "bigras.bruno@gmail.com";

    github = "bbigras";
    githubId = 24027;
  };
  bburdette = {
    name = "Ben Burdette";
    email = "bburdette@protonmail.com";

    github = "bburdette";
    githubId = 157330;
  };
  bcarrell = {
    name = "Brandon Carrell";
    email = "brandoncarrell@gmail.com";

    github = "bcarrell";
    githubId = 1015044;
  };
  bcc32 = {
    name = "Aaron Zeng";
    email = "me@bcc32.com";

    github = "bcc32";
    githubId = 1239097;
  };
  bcdarwin = {
    name = "Ben Darwin";
    email = "bcdarwin@gmail.com";

    github = "bcdarwin";
    githubId = 164148;
  };
  bdd = {
    name = "Berk D. Demir";
    email = "bdd@mindcast.org";

    github = "bdd";
    githubId = 11135;
  };
  bdesham = {
    name = "Benjamin Esham";
    email = "benjamin@esham.io";

    github = "bdesham";
    githubId = 354230;
  };
  bdimcheff = {
    name = "Brandon Dimcheff";
    email = "brandon@dimcheff.com";

    github = "bdimcheff";
    githubId = 14111;
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
    name = "Herwig Hochleitner";
    email = "herwig@bendlas.net";

    matrix = "@bendlas:matrix.org";
    github = "bendlas";
    githubId = 214787;
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
    name = "Benjamin Staffin";
    email = "benley@gmail.com";

    github = "benley";
    githubId = 1432730;
  };
  benneti = {
    name = "Benedikt Tissot";
    email = "benedikt.tissot@googlemail.com";

    github = "benneti";
    githubId = 11725645;
  };
  bennofs = {
    name = "Benno Fünfstück";
    email = "benno.fuenfstueck@gmail.com";

    github = "bennofs";
    githubId = 3192959;
  };
  benpye = {
    name = "Ben Pye";
    email = "ben@curlybracket.co.uk";

    github = "benpye";
    githubId = 442623;
  };
  berberman = {
    name = "Potato Hatsue";
    email = "berberman@yandex.com";

    matrix = "@berberman:mozilla.org";
    github = "berberman";
    githubId = 26041945;
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
  berce = {
    name = "Bert Moens";
    email = "bert.moens@gmail.com";

    github = "berce";
    githubId = 10439709;
  };
  berdario = {
    name = "Dario Bertini";
    email = "berdario@gmail.com";

    github = "berdario";
    githubId = 752835;
  };
  bergey = {
    name = "Daniel Bergey";
    email = "bergey@teallabs.org";

    github = "bergey";
    githubId = 251106;
  };
  bergkvist = {
    name = "Tobias Bergkvist";
    email = "tobias@bergkv.ist";

    github = "bergkvist";
    githubId = 410028;
  };
  berryp = {
    name = "Berry Phillips";
    email = "berryphillips@gmail.com";

    github = "berryp";
    githubId = 19911;
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
  betaboon = {
    name = "betaboon";
    email = "betaboon@0x80.ninja";

    github = "betaboon";
    githubId = 7346933;
  };
  bew = {
    name = "Benoit de Chezelles";
    email = "benoit.dechezelles@gmail.com";

    github = "bew";
    githubId = 9730330;
  };
  bezmuth = {
    name = "Ben Kelly";
    email = "benkel97@protonmail.com";

    github = "bezmuth";
    githubId = 31394095;
  };
  bfortz = {
    name = "Bernard Fortz";
    email = "bernard.fortz@gmail.com";

    github = "bfortz";
    githubId = 16426882;
  };
  bgamari = {
    name = "Ben Gamari";
    email = "ben@smart-cactus.org";

    github = "bgamari";
    githubId = 1010174;
  };
  bhall = {
    name = "Brendan Hall";
    email = "brendan.j.hall@bath.edu";

    github = "brendan-hall";
    githubId = 34919100;
  };
  bhipple = {
    name = "Benjamin Hipple";
    email = "bhipple@protonmail.com";

    github = "bhipple";
    githubId = 2071583;
  };
  bhougland = {
    name = "Benjamin Hougland";
    email = "benjamin.hougland@gmail.com";

    github = "bhougland18";
    githubId = 28444296;
  };
  bigzilla = {
    name = "Billy Zaelani Malik";
    email = "m.billyzaelani@gmail.com";

    github = "bigzilla";
    githubId = 20436235;
  };
  billewanick = {
    name = "Bill Ewanick";
    email = "bill@ewanick.com";

    github = "billewanick";
    githubId = 13324165;
  };
  billhuang = {
    name = "Bill Huang";
    email = "bill.huang2001@gmail.com";

    github = "BillHuang2001";
    githubId = 11801831;
  };
  binarin = {
    name = "Alexey Lebedeff";
    email = "binarin@binarin.ru";

    github = "binarin";
    githubId = 185443;
  };
  binsky = {
    name = "Timo Triebensky";
    email = "timo@binsky.org";

    github = "binsky08";
    githubId = 30630233;
  };
  bjornfor = {
    name = "Bjørn Forsman";
    email = "bjorn.forsman@gmail.com";

    github = "bjornfor";
    githubId = 133602;
  };
  bkchr = {
    name = "Bastian Köcher";
    email = "nixos@kchr.de";

    github = "bkchr";
    githubId = 5718007;
  };
  blaggacao = {
    name = "David Arnold";
    email = "dar@xoe.solutions";

    github = "blaggacao";
    githubId = 7548295;
  };
  blanky0230 = {
    name = "Thomas Blank";
    email = "blanky0230@gmail.com";

    github = "blanky0230";
    githubId = 5700358;
  };
  blitz = {
    name = "Julian Stecklina";
    email = "js@alien8.de";

    matrix = "@js:ukvly.org";
    github = "blitz";
    githubId = 37907;
  };
  bluescreen303 = {
    name = "Mathijs Kwik";
    email = "mathijs@bluescreen303.nl";

    github = "bluescreen303";
    githubId = 16330;
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
    name = "Bo Bakker";
    email = "bobakk3r@gmail.com";

    github = "bobakker";
    githubId = 10221570;
  };
  bobby285271 = {
    name = "Bobby Rong";
    email = "rjl931189261@126.com";

    matrix = "@bobby285271:matrix.org";
    github = "bobby285271";
    githubId = 20080233;
  };
  bobvanderlinden = {
    name = "Bob van der Linden";
    email = "bobvanderlinden@gmail.com";

    github = "bobvanderlinden";
    githubId = 6375609;
  };
  bodil = {
    name = "Bodil Stokke";
    email = "nix@bodil.org";

    github = "bodil";
    githubId = 17880;
  };
  boj = {
    name = "Brian Jones";
    email = "brian@uncannyworks.com";

    github = "boj";
    githubId = 50839;
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
    name = "bootstrap-prime";
    email = "bootstrap.prime@gmail.com";

    github = "bootstrap-prime";
    githubId = 68566724;
  };
  boppyt = {
    name = "Zack A";
    email = "boppy@nwcpz.com";

    github = "boppyt";
    githubId = 71049646;
    keys = [{
      fingerprint = "E8D7 5C19 9F65 269B 439D  F77B 6310 C97D E31D 1545";
    }];
  };
  borisbabic = {
    name = "Boris Babić";
    email = "boris.ivan.babic@gmail.com";

    github = "borisbabic";
    githubId = 1743184;
  };
  borlaag = {
    name = "Børlaag";
    email = "borlaag@proton.me";

    github = "Borlaag";
    githubId = 114830266;
  };
  bosu = {
    name = "Boris Sukholitko";
    email = "boriss@gmail.com";

    github = "bosu";
    githubId = 3465841;
  };
  bouk = {
    name = "Bouke van der Bijl";
    email = "i@bou.ke";

    github = "bouk";
    githubId = 97820;
  };
  bpaulin = {
    name = "bpaulin";
    email = "brunopaulin@bpaulin.net";

    github = "bpaulin";
    githubId = 115711;
  };
  Br1ght0ne = {
    name = "Oleksii Filonenko";
    email = "brightone@protonmail.com";

    github = "Br1ght0ne";
    githubId = 12615679;
    keys = [{
      fingerprint = "F549 3B7F 9372 5578 FDD3  D0B8 A1BC 8428 323E CFE8";
    }];
  };
  bradediger = {
    name = "Brad Ediger";
    email = "brad@bradediger.com";

    github = "bradediger";
    githubId = 4621;
  };
  brainrape = {
    name = "Marton Boros";
    email = "martonboros@gmail.com";

    github = "brainrake";
    githubId = 302429;
  };
  bramd = {
    name = "Bram Duvigneau";
    email = "bram@bramd.nl";

    github = "bramd";
    githubId = 86652;
  };
  braydenjw = {
    name = "Brayden Willenborg";
    email = "nixpkgs@willenborg.ca";

    github = "braydenjw";
    githubId = 2506621;
  };
  breakds = {
    name = "Break Yang";
    email = "breakds@gmail.com";

    github = "breakds";
    githubId = 1111035;
  };
  brecht = {
    name = "Brecht Savelkoul";
    email = "brecht.savelkoul@alumni.lse.ac.uk";

    github = "brechtcs";
    githubId = 6107054;
  };
  brendanreis = {
    name = "Brendan Reis";
    email = "brendanreis@gmail.com";

    github = "brendanreis";
    githubId = 10686906;
  };
  brettlyons = {
    name = "Brett Lyons";
    email = "blyons@fastmail.com";

    github = "brettlyons";
    githubId = 3043718;
  };
  brian-dawn = {
    name = "Brian Dawn";
    email = "brian.t.dawn@gmail.com";

    github = "brian-dawn";
    githubId = 1274409;
  };
  brianhicks = {
    name = "Brian Hicks";
    email = "brian@brianthicks.com";

    github = "BrianHicks";
    githubId = 355401;
  };
  brianmcgee = {
    name = "Brian McGee";
    email = "brian@41north.dev";

    github = "brianmcgee";
    githubId = 1173648;
  };
  brodes = {
    name = "Billy Rhoades";
    email = "me@brod.es";

    github = "brhoades";
    githubId = 4763746;
    keys = [{
      fingerprint = "BF4FCB85C69989B4ED95BF938AE74787A4B7C07E";
    }];
  };
  broke = {
    name = "Gunnar Nitsche";
    email = "broke@in-fucking.space";

    github = "broke";
    githubId = 1071610;
  };
  bryanasdev000 = {
    name = "Bryan Albuquerque";
    email = "bryanasdev000@gmail.com";

    matrix = "@bryanasdev000:matrix.org";
    github = "bryanasdev000";
    githubId = 53131727;
  };
  bryanhonof = {
    name = "Bryan Honof";
    email = "bryanhonof@gmail.com";

    github = "bryanhonof";
    githubId = 5932804;
  };
  bsima = {
    name = "Ben Sima";
    email = "ben@bsima.me";

    github = "bsima";
    githubId = 200617;
  };
  bstrik = {
    name = "Berno Strik";
    email = "dutchman55@gmx.com";

    github = "bstrik";
    githubId = 7716744;
  };
  btlvr = {
    name = "Brett L";
    email = "btlvr@protonmail.com";

    github = "btlvr";
    githubId = 32319131;
  };
  buckley310 = {
    name = "Sean Buckley";
    email = "sean.bck@gmail.com";

    matrix = "@buckley310:matrix.org";
    github = "buckley310";
    githubId = 2379774;
  };
  buffet = {
    name = "Niclas Meyer";
    email = "niclas@countingsort.com";

    github = "buffet";
    githubId = 33751841;
  };
  bugworm = {
    name = "Roman Gerasimenko";
    email = "bugworm@zoho.com";

    github = "bugworm";
    githubId = 7214361;
  };
  builditluc = {
    name = "Buildit";
    email = "builditluc@icloud.com";

    github = "Builditluc";
    githubId = 37375448;
  };
  bwlang = {
    name = "Brad Langhorst";
    email = "brad@langhorst.com";

    github = "bwlang";
    githubId = 61636;
  };
  bzizou = {
    name = "Bruno Bzeznik";
    email = "Bruno@bzizou.net";

    github = "bzizou";
    githubId = 2647566;
  };
  c00w = {
    name = "Colin";
    email = "nix@daedrum.net";

    github = "c00w";
    githubId = 486199;
  };
  c0bw3b = {
    name = "Renaud";
    email = "c0bw3b@gmail.com";

    github = "c0bw3b";
    githubId = 24417923;
  };
  c0deaddict = {
    name = "Jos van Bakel";
    email = "josvanbakel@protonmail.com";

    github = "c0deaddict";
    githubId = 510553;
  };
  c4605 = {
    name = "c4605";
    email = "bolasblack@gmail.com";

    github = "bolasblack";
    githubId = 382011;
  };
  caadar = {
    name = "Car Cdr";
    email = "v88m@posteo.net";

    github = "caadar";
    githubId = 15320726;
  };
  cab404 = {
    name = "Vladimir Serov";
    email = "cab404@mailbox.org";

    github = "cab404";
    githubId = 6453661;
    keys = [
      {
        fingerprint = "1BB96810926F4E715DEF567E6BA7C26C3FDF7BB3";
      }

      {
        fingerprint = "1EBC648C64D6045463013B3EB7EFFC271D55DB8A";
      }
    ];
  };
  CactiChameleon9 = {
    name = "Daniel";
    email = "h19xjkkp@duck.com";

    github = "CactiChameleon9";
    githubId = 51231053;
  };
  cafkafk = {
    name = "Christina Sørensen";
    email = "christina@cafkafk.com";

    matrix = "@cafkafk:matrix.cafkafk.com";
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
  calavera = {
    name = "David Calavera";
    email = "david.calavera@gmail.com";

    matrix = "@davidcalavera:matrix.org";
    github = "calavera";
    githubId = 1050;
  };
  calbrecht = {
    name = "Christian Albrecht";
    email = "christian.albrecht@mayflower.de";

    github = "calbrecht";
    githubId = 1516457;
  };
  callahad = {
    name = "Dan Callahan";
    email = "dan.callahan@gmail.com";

    github = "callahad";
    githubId = 24193;
  };
  calvertvl = {
    name = "Victor Calvert";
    email = "calvertvl@gmail.com";

    github = "calvertvl";
    githubId = 7435854;
  };
  cameronfyfe = {
    name = "Cameron Fyfe";
    email = "cameron.j.fyfe@gmail.com";

    github = "cameronfyfe";
    githubId = 21013281;
  };
  cameronnemo = {
    name = "Cameron Nemo";
    email = "cnemo@tutanota.com";

    github = "CameronNemo";
    githubId = 3212452;
  };
  campadrenalin = {
    name = "Philip Horger";
    email = "campadrenalin@gmail.com";

    github = "campadrenalin";
    githubId = 289492;
  };
  candeira = {
    name = "Javier Candeira";
    email = "javier@candeira.com";

    github = "candeira";
    githubId = 91694;
  };
  candyc1oud = {
    name = "Candy Cloud";
    email = "candyc1oud@outlook.com";

    github = "candyc1oud";
    githubId = 113157395;
  };
  canndrew = {
    name = "Andrew Cann";
    email = "shum@canndrew.org";

    github = "canndrew";
    githubId = 5555066;
  };
  cap = {
    name = "cap";
    email = "nixos_xasenw9@digitalpostkasten.de";

    github = "scaredmushroom";
    githubId = 45340040;
  };
  CaptainJawZ = {
    name = "Danilo Reyes";
    email = "CaptainJawZ@outlook.com";

    github = "CaptainJawZ";
    githubId = 43111068;
  };
  carlosdagos = {
    name = "Carlos D'Agostino";
    email = "m@cdagostino.io";

    github = "carlosdagos";
    githubId = 686190;
  };
  carlsverre = {
    name = "Carl Sverre";
    email = "accounts@carlsverre.com";

    github = "carlsverre";
    githubId = 82591;
  };
  carpinchomug = {
    name = "Akiyoshi Suda";
    email = "aki.suda@protonmail.com";

    github = "carpinchomug";
    githubId = 101536256;
  };
  cartr = {
    name = "Carter Sande";
    email = "carter.sande@duodecima.technology";

    github = "cartr";
    githubId = 5241813;
  };
  casey = {
    name = "Casey Rodarmor";
    email = "casey@rodarmor.net";

    github = "casey";
    githubId = 1945;
  };
  catap = {
    name = "Kirill A. Korinsky";
    email = "kirill@korins.ky";

    github = "catap";
    githubId = 37775;
  };
  catern = {
    name = "Spencer Baugh";
    email = "sbaugh@catern.com";

    github = "catern";
    githubId = 5394722;
  };
  catouc = {
    name = "Philipp Böschen";
    email = "catouc@philipp.boeschen.me";

    github = "catouc";
    githubId = 25623213;
  };
  caugner = {
    name = "Claas Augner";
    email = "nixos@caugner.de";

    github = "caugner";
    githubId = 495429;
  };
  cawilliamson = {
    name = "Christopher A. Williamson";
    email = "home@chrisaw.com";

    matrix = "@cawilliamson:nixos.dev";
    github = "cawilliamson";
    githubId = 1141769;
  };
  cbley = {
    name = "Claudio Bley";
    email = "claudio.bley@gmail.com";

    github = "avdv";
    githubId = 3471749;
  };
  cburstedde = {
    name = "Carsten Burstedde";
    email = "burstedde@ins.uni-bonn.de";

    github = "cburstedde";
    githubId = 109908;
    keys = [{
      fingerprint = "1127 A432 6524 BF02 737B  544E 0704 CD9E 550A 6BCD";
    }];
  };
  ccellado = {
    name = "Denis Khalmatov";
    email = "annplague@gmail.com";

    github = "ccellado";
    githubId = 44584960;
  };
  cdepillabout = {
    name = "Dennis Gosnell";
    email = "cdep.illabout@gmail.com";

    matrix = "@cdepillabout:matrix.org";
    github = "cdepillabout";
    githubId = 64804;
  };
  ceedubs = {
    name = "Cody Allen";
    email = "ceedubs@gmail.com";

    github = "ceedubs";
    githubId = 977929;
  };
  centromere = {
    name = "Alex Wied";
    email = "nix@centromere.net";

    github = "centromere";
    githubId = 543423;
  };
  cfhammill = {
    name = "Chris Hammill";
    email = "cfhammill@gmail.com";

    github = "cfhammill";
    githubId = 7467038;
  };
  cfouche = {
    name = "Chaddaï Fouché";
    email = "chaddai.fouche@gmail.com";

    github = "Chaddai";
    githubId = 5771456;
  };
  cfsmp3 = {
    name = "Carlos Fernandez Sanz";
    email = "carlos@sanz.dev";

    github = "cfsmp3";
    githubId = 5949913;
  };
  cge = {
    name = "Constantine Evans";
    email = "cevans@evanslabs.org";

    github = "cgevans";
    githubId = 2054509;
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
    name = "Charles Duffy";
    email = "charles@dyfis.net";

    github = "charles-dyfis-net";
    githubId = 22370;
  };
  changlinli = {
    name = "Changlin Li";
    email = "mail@changlinli.com";

    github = "changlinli";
    githubId = 1762540;
  };
  chanley = {
    name = "Charlie Hanley";
    email = "charlieshanley@gmail.com";

    github = "charlieshanley";
    githubId = 8228888;
  };
  chaoflow = {
    name = "Florian Friesdorf";
    email = "flo@chaoflow.net";

    github = "chaoflow";
    githubId = 89596;
  };
  charlesbaynham = {
    name = "Charles Baynham";
    email = "charlesbaynham@gmail.com";

    github = "charlesbaynham";
    githubId = 4397637;
  };
  CharlesHD = {
    name = "Charles Huyghues-Despointes";
    email = "charleshdespointes@gmail.com";

    github = "CharlesHD";
    githubId = 6608071;
  };
  chekoopa = {
    name = "Mikhail Chekan";
    email = "chekoopa@mail.ru";

    github = "chekoopa";
    githubId = 1689801;
  };
  ChengCat = {
    name = "Yucheng Zhang";
    email = "yu@cheng.cat";

    github = "ChengCat";
    githubId = 33503784;
  };
  cheriimoya = {
    name = "Max Hausch";
    email = "github@hausch.xyz";

    github = "cheriimoya";
    githubId = 28303440;
  };
  chessai = {
    name = "Daniel Cartwright";
    email = "chessai1996@gmail.com";

    github = "chessai";
    githubId = 18648043;
  };
  Chili-Man = {
    name = "Diego Rodriguez";
    email = "dr.elhombrechile@gmail.com";

    github = "Chili-Man";
    githubId = 631802;
    keys = [{
      fingerprint = "099E 3F97 FA08 3D47 8C75  EBEC E0EB AD78 F019 0BD9";
    }];
  };
  chiroptical = {
    name = "Barry Moore II";
    email = "chiroptical@gmail.com";

    github = "chiroptical";
    githubId = 3086255;
  };
  chisui = {
    name = "Philipp Dargel";
    email = "chisui.pd@gmail.com";

    github = "chisui";
    githubId = 4526429;
  };
  chivay = {
    name = "Hubert Jasudowicz";
    email = "hubert.jasudowicz@gmail.com";

    github = "chivay";
    githubId = 14790226;
  };
  chkno = {
    name = "Scott Worley";
    email = "chuck@intelligence.org";

    github = "chkno";
    githubId = 1118859;
  };
  choochootrain = {
    name = "Hurshal Patel";
    email = "hurshal@imap.cc";

    github = "choochootrain";
    githubId = 803961;
  };
  chpatrick = {
    name = "Patrick Chilton";
    email = "chpatrick@gmail.com";

    github = "chpatrick";
    githubId = 832719;
  };
  chreekat = {
    name = "Bryan Richter";
    email = "b@chreekat.net";

    github = "chreekat";
    githubId = 538538;
  };
  chris-martin = {
    name = "Chris Martin";
    email = "ch.martin@gmail.com";

    github = "chris-martin";
    githubId = 399718;
  };
  chrisjefferson = {
    name = "Christopher Jefferson";
    email = "chris@bubblescope.net";

    github = "ChrisJefferson";
    githubId = 811527;
  };
  chrispattison = {
    name = "Chris Pattison";
    email = "chpattison@gmail.com";

    github = "ChrisPattison";
    githubId = 641627;
  };
  chrispickard = {
    name = "Chris Pickard";
    email = "chrispickard9@gmail.com";

    github = "chrispickard";
    githubId = 1438690;
  };
  chrisrosset = {
    name = "Christopher Rosset";
    email = "chris@rosset.org.uk";

    github = "chrisrosset";
    githubId = 1103294;
  };
  christianharke = {
    name = "Christian Harke";
    email = "christian@harke.ch";

    github = "christianharke";
    githubId = 13007345;
    keys = [{
      fingerprint = "4EBB 30F1 E89A 541A A7F2  52BE 830A 9728 6309 66F4";
    }];
  };
  christophcharles = {
    name = "Christoph Charles";
    email = "23055925+christophcharles@users.noreply.github.com";

    github = "christophcharles";
    githubId = 23055925;
  };
  christopherpoole = {
    name = "Christopher Mark Poole";
    email = "mail@christopherpoole.net";

    github = "christopherpoole";
    githubId = 2245737;
  };
  chuahou = {
    name = "Chua Hou";
    email = "human+github@chuahou.dev";

    github = "chuahou";
    githubId = 12386805;
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
    name = "Charlotte Van Petegem";
    email = "nixpkgs@cvpetegem.be";

    matrix = "@charlotte:vanpetegem.me";
    github = "chvp";
    githubId = 42220376;
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
    name = "Simon Lackerbauer";
    email = "simon@lackerbauer.com";

    github = "ciil";
    githubId = 3956062;
  };
  cimm = {
    name = "Simon";
    email = "8k9ft8m5gv@astil.be";

    github = "cimm";
    githubId = 68112;
  };
  cirno-999 = {
    name = "cirno-999";
    email = "reverene@protonmail.com";

    github = "cirno-999";
    githubId = 73712874;
  };
  citadelcore = {
    name = "Alex Zero";
    email = "alex@arctarus.co.uk";

    github = "CitadelCore";
    githubId = 5567402;
    keys = [{
      fingerprint = "A0AA 4646 B8F6 9D45 4553  5A88 A515 50ED B450 302C";
    }];
  };
  cizra = {
    name = "Elmo Todurov";
    email = "todurov+nix@gmail.com";

    github = "cizra";
    githubId = 2131991;
  };
  cjab = {
    name = "Chad Jablonski";
    email = "chad+nixpkgs@jablonski.xyz";

    github = "cjab";
    githubId = 136485;
  };
  ck3d = {
    name = "Christian Kögler";
    email = "ck3d@gmx.de";

    github = "ck3d";
    githubId = 25088352;
  };
  ckauhaus = {
    name = "Christian Kauhaus";
    email = "kc@flyingcircus.io";

    github = "ckauhaus";
    githubId = 1448923;
  };
  ckie = {
    name = "ckie";
    email = "nixpkgs-0efe364@ckie.dev";

    matrix = "@ckie:ckie.dev";
    github = "ckiee";
    githubId = 25263210;
    keys = [{
      fingerprint = "539F 0655 4D35 38A5 429A  E253 13E7 9449 C052 5215";
    }];
  };
  cko = {
    name = "Christine Koppelt";
    email = "christine.koppelt@gmail.com";

    github = "cko";
    githubId = 68239;
  };
  clacke = {
    name = "Claes Wallin";
    email = "claes.wallin@greatsinodevelopment.com";

    github = "clacke";
    githubId = 199180;
  };
  cleeyv = {
    name = "Cleeyv";
    email = "cleeyv@riseup.net";

    github = "cleeyv";
    githubId = 71959829;
  };
  clerie = {
    name = "clerie";
    email = "nix@clerie.de";

    github = "clerie";
    githubId = 9381848;
  };
  cleverca22 = {
    name = "Michael Bishop";
    email = "cleverca22@gmail.com";

    matrix = "@cleverca22:matrix.org";
    github = "cleverca22";
    githubId = 848609;
  };
  clkamp = {
    name = "Christian Lütke-Stetzkamp";
    email = "c@lkamp.de";

    github = "clkamp";
    githubId = 46303707;
  };
  cmacrae = {
    name = "Calum MacRae";
    email = "hi@cmacr.ae";

    github = "cmacrae";
    githubId = 3392199;
  };
  cmars = {
    name = "Casey Marshall";
    email = "nix@cmars.tech";

    github = "cmars";
    githubId = 23741;
    keys = [{
      fingerprint = "6B78 7E5F B493 FA4F D009  5D10 6DEC 2758 ACD5 A973";
    }];
  };
  cmcdragonkai = {
    name = "Roger Qiu";
    email = "roger.qiu@matrix.ai";

    github = "CMCDragonkai";
    githubId = 640797;
  };
  cmfwyp = {
    name = "cmfwyp";
    email = "cmfwyp@riseup.net";

    github = "cmfwyp";
    githubId = 20808761;
  };
  cmm = {
    name = "Michael Livshin";
    email = "repo@cmm.kakpryg.net";

    github = "cmm";
    githubId = 718298;
  };
  cobbal = {
    name = "Andrew Cobb";
    email = "andrew.cobb@gmail.com";

    github = "cobbal";
    githubId = 180339;
  };
  coconnor = {
    name = "Corey O'Connor";
    email = "coreyoconnor@gmail.com";

    github = "coreyoconnor";
    githubId = 34317;
  };
  CodeLongAndProsper90 = {
    name = "Scott Little";
    email = "jupiter@m.rdis.dev";

    github = "CodeLongAndProsper90";
    githubId = 50145141;
  };
  codsl = {
    name = "codsl";
    email = "codsl@riseup.net";

    github = "codsl";
    githubId = 6402559;
  };
  codyopel = {
    name = "Cody Opel";
    email = "codyopel@gmail.com";

    github = "codyopel";
    githubId = 5561189;
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
    name = "Rasmus Thomsen";
    email = "oss@cogitri.dev";

    matrix = "@cogitri:cogitri.dev";
    github = "Cogitri";
    githubId = 8766773;
  };
  cohei = {
    name = "TANIGUCHI Kohei";
    email = "a.d.xvii.kal.mai@gmail.com";

    github = "cohei";
    githubId = 3477497;
  };
  cohencyril = {
    name = "Cyril Cohen";
    email = "cyril.cohen@inria.fr";

    github = "CohenCyril";
    githubId = 298705;
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
  colemickens = {
    name = "Cole Mickens";
    email = "cole.mickens@gmail.com";

    matrix = "@colemickens:matrix.org";
    github = "colemickens";
    githubId = 327028;
  };
  colescott = {
    name = "Cole Scott";
    email = "colescottsf@gmail.com";

    github = "colescott";
    githubId = 5684605;
  };
  colinsane = {
    name = "Colin Sane";
    email = "colin@uninsane.org";

    matrix = "@colin:uninsane.org";
    github = "uninsane";
    githubId = 106709944;
  };
  collares = {
    name = "Mauricio Collares";
    email = "mauricio@collares.org";

    github = "collares";
    githubId = 244239;
  };
  commandodev = {
    name = "Ben Ford";
    email = "ben@perurbis.com";

    github = "commandodev";
    githubId = 87764;
  };
  CompEng0001 = {
    name = "Seb Blair";
    email = "sb1501@canterbury.ac.uk";

    github = "CompEng0001";
    githubId = 40290417;
  };
  confus = {
    name = "J.C.";
    email = "con-f-use@gmx.net";

    github = "con-f-use";
    githubId = 11145016;
  };
  congee = {
    name = "Changsheng Wu";
    email = "changshengwu@pm.me";

    matrix = "@congeec:matrix.org";
    github = "Congee";
    githubId = 2083950;
  };
  conradmearns = {
    name = "Conrad Mearns";
    email = "conradmearns+github@pm.me";

    github = "ConradMearns";
    githubId = 5510514;
  };
  considerate = {
    name = "Viktor Kronvall";
    email = "viktor.kronvall@gmail.com";

    github = "considerate";
    githubId = 217918;
  };
  contrun = {
    name = "B YI";
    email = "uuuuuu@protonmail.com";

    github = "contrun";
    githubId = 32609395;
  };
  copumpkin = {
    name = "Dan Peebles";
    email = "pumpkingod@gmail.com";

    github = "copumpkin";
    githubId = 2623;
  };
  corbanr = {
    name = "Corban Raun";
    email = "corban@raunco.co";

    matrix = "@corbansolo:matrix.org";
    github = "CorbanR";
    githubId = 1918683;
    keys = [
      {
        fingerprint = "6607 0B24 8CE5 64ED 22CE  0950 A697 A56F 1F15 1189";
      }

      {
        fingerprint = "D8CB 816A B678 A4E6 1EC7  5325 230F 4AC1 53F9 0F29";
      }
    ];
  };
  corngood = {
    name = "David McFarland";
    email = "corngood@gmail.com";

    github = "corngood";
    githubId = 3077118;
  };
  coroa = {
    name = "Jonas Hörsch";
    email = "jonas@chaoflow.net";

    github = "coroa";
    githubId = 2552981;
  };
  costrouc = {
    name = "Chris Ostrouchov";
    email = "chris.ostrouchov@gmail.com";

    github = "costrouc";
    githubId = 1740337;
  };
  couchemar = {
    name = "Andrey Pavlov";
    email = "couchemar@yandex.ru";

    github = "couchemar";
    githubId = 1573344;
  };
  cpages = {
    name = "Carles Pagès";
    email = "page@ruiec.cat";

    github = "cpages";
    githubId = 411324;
  };
  cpcloud = {
    name = "Phillip Cloud";
    email = "417981+cpcloud@users.noreply.github.com";

    github = "cpcloud";
    githubId = 417981;
  };
  cpu = {
    name = "Daniel McCarney";
    email = "daniel@binaryparadox.net";

    github = "cpu";
    githubId = 292650;
    keys = [{
      fingerprint = "8026 D24A A966 BF9C D3CD  CB3C 08FB 2BFC 470E 75B4";
    }];
  };
  Crafter = {
    name = "Crafter";
    email = "crafter@crafter.rocks";

    github = "Craftzman7";
    githubId = 70068692;
  };
  craigem = {
    name = "Craige McWhirter";
    email = "craige@mcwhirter.io";

    github = "craigem";
    githubId = 6470493;
  };
  cransom = {
    name = "Casey Ransom";
    email = "cransom@hubns.net";

    github = "cransom";
    githubId = 1957293;
  };
  CrazedProgrammer = {
    name = "CrazedProgrammer";
    email = "crazedprogrammer@gmail.com";

    github = "CrazedProgrammer";
    githubId = 12202789;
  };
  creator54 = {
    name = "creator54";
    email = "hi.creator54@gmail.com";

    github = "Creator54";
    githubId = 34543609;
  };
  crinklywrappr = {
    name = "Daniel Fitzpatrick";
    email = "crinklywrappr@pm.me";

    github = "crinklywrappr";
    githubId = 56522;
  };
  cript0nauta = {
    name = "Matías Lang";
    email = "shareman1204@gmail.com";

    github = "cript0nauta";
    githubId = 1222362;
  };
  CRTified = {
    name = "Carl Richard Theodor Schneider";
    email = "carl.schneider+nixos@rub.de";

    matrix = "@schnecfk:ruhr-uni-bochum.de";
    github = "CRTified";
    githubId = 2440581;
    keys = [{
      fingerprint = "2017 E152 BB81 5C16 955C  E612 45BC C1E2 709B 1788";
    }];
  };
  cryptix = {
    name = "Henry Bubert";
    email = "cryptix@riseup.net";

    github = "cryptix";
    githubId = 111202;
  };
  CrystalGamma = {
    name = "Jona Stubbe";
    email = "nixos@crystalgamma.de";

    github = "CrystalGamma";
    githubId = 6297001;
  };
  csingley = {
    name = "Christopher Singley";
    email = "csingley@gmail.com";

    github = "csingley";
    githubId = 398996;
  };
  cstrahan = {
    name = "Charles Strahan";
    email = "charles@cstrahan.com";

    github = "cstrahan";
    githubId = 143982;
  };
  cswank = {
    name = "Craig Swank";
    email = "craigswank@gmail.com";

    github = "cswank";
    githubId = 490965;
  };
  cust0dian = {
    name = "Serg Nesterov";
    email = "serg@effectful.software";

    github = "cust0dian";
    githubId = 389387;
    keys = [{
      fingerprint = "6E7D BA30 DB5D BA60 693C  3BE3 1512 F6EB 84AE CC8C";
    }];
  };
  cwoac = {
    name = "Oliver Matthews";
    email = "oliver@codersoffortune.net";

    github = "cwoac";
    githubId = 1382175;
  };
  cwyc = {
    name = "cwyc";
    email = "hello@cwyc.page";

    github = "cwyc";
    githubId = 16950437;
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
    name = "Ștefan D. Mihăilă";
    email = "stefan.mihaila@pm.me";

    github = "stefan-mihaila";
    githubId = 2217136;
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
    name = "Cyryl Płotnicki";
    email = "nixos@cyplo.dev";

    matrix = "@cyplo:cyplo.dev";
    github = "cyplo";
    githubId = 217899;
  };
  d-goldin = {
    name = "Dima";
    email = "dgoldin+github@protonmail.ch";

    github = "d-goldin";
    githubId = 43349662;
    keys = [{
      fingerprint = "1C4E F4FE 7F8E D8B7 1E88 CCDF BAB1 D15F B7B4 D4CE";
    }];
  };
  d-xo = {
    name = "David Terry";
    email = "hi@d-xo.org";

    github = "d-xo";
    githubId = 6689924;
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
    name = "Naoya Hatta";
    email = "dalance@gmail.com";

    github = "dalance";
    githubId = 4331004;
  };
  dalpd = {
    name = "Deniz Alp Durmaz";
    email = "denizalpd@ogr.iu.edu.tr";

    github = "dalpd";
    githubId = 16895361;
  };
  DAlperin = {
    name = "Dov Alperin";
    email = "git@dov.dev";

    github = "DAlperin";
    githubId = 16063713;
    keys = [{
      fingerprint = "4EED 5096 B925 86FA 1101  6673 7F2C 07B9 1B52 BB61";
    }];
  };
  DamienCassou = {
    name = "Damien Cassou";
    email = "damien@cassou.me";

    github = "DamienCassou";
    githubId = 217543;
  };
  dan4ik605743 = {
    name = "Danil Danevich";
    email = "6057430gu@gmail.com";

    github = "dan4ik605743";
    githubId = 86075850;
  };
  danbst = {
    name = "Danylo Hlynskyi";
    email = "abcz2.uprola@gmail.com";

    github = "danbst";
    githubId = 743057;
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
    name = "Hannu Hartikainen";
    email = "hannu.hartikainen@gmail.com";

    github = "dancek";
    githubId = 245394;
  };
  dandellion = {
    name = "Daniel Olsen";
    email = "daniel@dodsorf.as";

    matrix = "@dandellion:dodsorf.as";
    github = "dali99";
    githubId = 990767;
  };
  danderson = {
    name = "David Anderson";
    email = "dave@natulte.net";

    github = "danderson";
    githubId = 1918;
  };
  daneads = {
    name = "Dan Eads";
    email = "me@daneads.com";

    github = "daneads";
    githubId = 24708079;
  };
  danielbarter = {
    name = "Daniel Barter";
    email = "danielbarter@gmail.com";

    github = "danielbarter";
    githubId = 8081722;
  };
  danieldk = {
    name = "Daniël de Kok";
    email = "me@danieldk.eu";

    github = "danieldk";
    githubId = 49398;
  };
  danielfullmer = {
    name = "Daniel Fullmer";
    email = "danielrf12@gmail.com";

    github = "danielfullmer";
    githubId = 1298344;
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
  darkonion0 = {
    name = "Alexandre Peruggia";
    email = "darkgenius1@protonmail.com";

    matrix = "@alexoo:matrix.org";
    github = "DarkOnion0";
    githubId = 68606322;
  };
  das-g = {
    name = "Raphael Das Gupta";
    email = "nixpkgs@raphael.dasgupta.ch";

    github = "das-g";
    githubId = 97746;
  };
  das_j = {
    name = "Janne Heß";
    email = "janne@hess.ooo";

    matrix = "@janne.hess:helsinki-systems.de";
    github = "dasJ";
    githubId = 4971975;
  };
  dasisdormax = {
    name = "Maximilian Wende";
    email = "dasisdormax@mailbox.org";

    github = "dasisdormax";
    githubId = 3714905;
    keys = [{
      fingerprint = "E59B A198 61B0 A9ED C1FA  3FB2 02BA 0D44 80CA 6C44";
    }];
  };
  dasj19 = {
    name = "Daniel Șerbănescu";
    email = "daniel@serbanescu.dk";

    github = "dasj19";
    githubId = 7589338;
  };
  datafoo = {
    name = "datafoo";
    email = "34766150+datafoo@users.noreply.github.com";

    github = "datafoo";
    githubId = 34766150;
  };
  davegallant = {
    name = "Dave Gallant";
    email = "davegallant@gmail.com";

    github = "davegallant";
    githubId = 4519234;
  };
  davhau = {
    name = "David Hauer";
    email = "d.hauer.it@gmail.com";

    github = "DavHau";
    githubId = 42246742;
  };
  david-sawatzke = {
    name = "David Sawatzke";
    email = "d-nix@sawatzke.dev";

    github = "david-sawatzke";
    githubId = 11035569;
  };
  david50407 = {
    name = "David Kuo";
    email = "me@davy.tw";

    github = "david50407";
    githubId = 841969;
  };
  davidak = {
    name = "David Kleuker";
    email = "post@davidak.de";

    matrix = "@davidak:matrix.org";
    github = "davidak";
    githubId = 91113;
  };
  davidarmstronglewis = {
    name = "David Armstrong Lewis";
    email = "davidlewis@mac.com";

    github = "davidarmstronglewis";
    githubId = 6754950;
  };
  davidrusu = {
    name = "David Rusu";
    email = "davidrusu.me@gmail.com";

    github = "davidrusu";
    githubId = 1832378;
  };
  davidtwco = {
    name = "David Wood";
    email = "david@davidtw.co";

    github = "davidtwco";
    githubId = 1295100;
    keys = [{
      fingerprint = "5B08 313C 6853 E5BF FA91  A817 0176 0B4F 9F53 F154";
    }];
  };
  davorb = {
    name = "Davor Babic";
    email = "davor@davor.se";

    github = "davorb";
    githubId = 798427;
  };
  dawidsowa = {
    name = "Dawid Sowa";
    email = "dawid_sowa@posteo.net";

    github = "dawidsowa";
    githubId = 49904992;
  };
  dbeckwith = {
    name = "Daniel Beckwith";
    email = "djbsnx@gmail.com";

    github = "dbeckwith";
    githubId = 1279939;
  };
  dbirks = {
    name = "David Birks";
    email = "david@birks.dev";

    github = "dbirks";
    githubId = 7545665;
    keys = [{
      fingerprint = "B26F 9AD8 DA20 3392 EF87  C61A BB99 9F83 D9A1 9A36";
    }];
  };
  dbohdan = {
    name = "D. Bohdan";
    email = "dbohdan@dbohdan.com";

    github = "dbohdan";
    githubId = 3179832;
  };
  dbrock = {
    name = "Daniel Brockman";
    email = "daniel@brockman.se";

    github = "dbrock";
    githubId = 14032;
  };
  ddelabru = {
    name = "Dominic Delabruere";
    email = "ddelabru@redhat.com";

    github = "ddelabru";
    githubId = 39909293;
  };
  dduan = {
    name = "Daniel Duan";
    email = "daniel@duan.ca";

    github = "dduan";
    githubId = 75067;
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
    name = "David Morgan";
    email = "nixpkgs.bu5hq@simplelogin.com";

    github = "deejayem";
    githubId = 2564003;
    keys = [{
      fingerprint = "9B43 6B14 77A8 79C2 6CDB  6604 C171 2510 02C2 00F2";
    }];
  };
  deepfire = {
    name = "Kosyrev Serge";
    email = "_deepfire@feelingofgreen.ru";

    github = "deepfire";
    githubId = 452652;
  };
  DeeUnderscore = {
    name = "D Anzorge";
    email = "d.anzorge@gmail.com";

    github = "DeeUnderscore";
    githubId = 156239;
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
    name = "deliciouslytyped";
    email = "47436522+deliciouslytyped@users.noreply.github.com";

    github = "deliciouslytyped";
    githubId = 47436522;
  };
  delroth = {
    name = "Pierre Bourdon";
    email = "delroth@gmail.com";

    github = "delroth";
    githubId = 202798;
  };
  delta = {
    name = "Delta";
    email = "d4delta@outlook.fr";

    github = "D4Delta";
    githubId = 12224254;
  };
  deltadelta = {
    name = "Dara Ly";
    email = "contact@libellules.eu";

    github = "tournemire";
    githubId = 20159432;
  };
  deltaevo = {
    name = "Duarte David";
    email = "deltaduartedavid@gmail.com";

    github = "DeltaEvo";
    githubId = 8864716;
  };
  demin-dmitriy = {
    name = "Dmitriy Demin";
    email = "demindf@gmail.com";

    github = "demin-dmitriy";
    githubId = 5503422;
  };
  demize = {
    name = "Johannes Löthberg";
    email = "johannes@kyriasis.com";

    github = "kyrias";
    githubId = 2285387;
  };
  demyanrogozhin = {
    name = "Demyan Rogozhin";
    email = "demyan.rogozhin@gmail.com";

    github = "demyanrogozhin";
    githubId = 62989;
  };
  derchris = {
    name = "Christian Gerbrandt";
    email = "derchris@me.com";

    github = "derchrisuk";
    githubId = 706758;
  };
  derekcollison = {
    name = "Derek Collison";
    email = "derek@nats.io";

    github = "derekcollison";
    githubId = 90097;
  };
  DerGuteMoritz = {
    name = "Moritz Heidkamp";
    email = "moritz@twoticketsplease.de";

    github = "DerGuteMoritz";
    githubId = 19733;
  };
  DerickEddington = {
    name = "Derick Eddington";
    email = "derick.eddington@pm.me";

    github = "DerickEddington";
    githubId = 4731128;
  };
  dermetfan = {
    name = "Robin Stumm";
    email = "serverkorken@gmail.com";

    github = "dermetfan";
    githubId = 4956158;
  };
  DerTim1 = {
    name = "Tim Digel";
    email = "tim.digel@active-group.de";

    github = "DerTim1";
    githubId = 21953890;
  };
  desiderius = {
    name = "Didier J. Devroye";
    email = "didier@devroye.name";

    github = "desiderius";
    githubId = 1311761;
  };
  desttinghim = {
    name = "Louis Pearson";
    email = "opensource@louispearson.work";

    matrix = "@desttinghim:matrix.org";
    github = "desttinghim";
    githubId = 10042482;
  };
  detegr = {
    name = "Antti Keränen";
    email = "detegr@rbx.email";

    github = "Detegr";
    githubId = 724433;
  };
  Dettorer = {
    name = "Paul Hervot";
    email = "paul.hervot@dettorer.net";

    matrix = "@dettorer:matrix.org";
    github = "Dettorer";
    githubId = 2761682;
  };
  devhell = {
    name = "devhell";
    email = "\"^\"@regexmail.net";

    github = "devhell";
    githubId = 896182;
  };
  devins2518 = {
    name = "Devin Singh";
    email = "drsingh2518@icloud.com";

    github = "devins2518";
    githubId = 17111639;
  };
  devusb = {
    name = "Morgan Helton";
    email = "mhelton@devusb.us";

    github = "devusb";
    githubId = 4951663;
  };
  dezgeg = {
    name = "Tuomas Tynkkynen";
    email = "tuomas.tynkkynen@iki.fi";

    github = "dezgeg";
    githubId = 579369;
  };
  dfithian = {
    name = "Daniel Fithian";
    email = "daniel.m.fithian@gmail.com";

    github = "dfithian";
    githubId = 8409320;
  };
  dfordivam = {
    name = "Divam";
    email = "dfordivam+nixpkgs@gmail.com";

    github = "dfordivam";
    githubId = 681060;
  };
  dfoxfranke = {
    name = "Daniel Fox Franke";
    email = "dfoxfranke@gmail.com";

    github = "dfoxfranke";
    githubId = 4708206;
  };
  dgliwka = {
    name = "Dawid Gliwka";
    email = "dawid.gliwka@gmail.com";

    github = "dgliwka";
    githubId = 33262214;
  };
  dgonyeo = {
    name = "Derek Gonyeo";
    email = "derek@gonyeo.com";

    github = "dgonyeo";
    githubId = 2439413;
  };
  dguenther = {
    name = "Derek Guenther";
    email = "dguenther9@gmail.com";

    github = "dguenther";
    githubId = 767083;
  };
  dhkl = {
    name = "David Leung";
    email = "david@davidslab.com";

    github = "dhl";
    githubId = 265220;
  };
  DianaOlympos = {
    name = "Thomas Depierre";
    email = "DianaOlympos@noreply.github.com";

    github = "DianaOlympos";
    githubId = 15774340;
  };
  diegolelis = {
    name = "Diego Lelis";
    email = "diego.o.lelis@gmail.com";

    github = "DiegoLelis";
    githubId = 8404455;
  };
  DieracDelta = {
    name = "Justin Restivo";
    email = "justin@restivo.me";

    github = "DieracDelta";
    githubId = 13730968;
  };
  diffumist = {
    name = "Diffumist";
    email = "git@diffumist.me";

    github = "Diffumist";
    githubId = 32810399;
  };
  diogox = {
    name = "Diogo Xavier";
    email = "13244408+diogox@users.noreply.github.com";

    github = "diogox";
    githubId = 13244408;
  };
  dipinhora = {
    name = "Dipin Hora";
    email = "dipinhora+github@gmail.com";

    github = "dipinhora";
    githubId = 11946442;
  };
  dirkx = {
    name = "Dirk-Willem van Gulik";
    email = "dirkx@webweaving.org";

    github = "dirkx";
    githubId = 392583;
  };
  disassembler = {
    name = "Samuel Leathers";
    email = "disasm@gmail.com";

    github = "disassembler";
    githubId = 651205;
  };
  disserman = {
    name = "Sergei S.";
    email = "disserman@gmail.com";

    github = "divi255";
    githubId = 40633781;
  };
  dit7ya = {
    name = "Mostly Void";
    email = "7rat13@gmail.com";

    github = "dit7ya";
    githubId = 14034137;
  };
  dizfer = {
    name = "David Izquierdo";
    email = "david@izquierdofernandez.com";

    github = "DIzFer";
    githubId = 8852888;
  };
  djacu = {
    name = "Daniel Baker";
    email = "daniel.n.baker@gmail.com";

    github = "djacu";
    githubId = 7043297;
  };
  djanatyn = {
    name = "Jonathan Strickland";
    email = "djanatyn@gmail.com";

    github = "djanatyn";
    githubId = 523628;
  };
  Dje4321 = {
    name = "Dje4321";
    email = "dje4321@gmail.com";

    github = "dje4321";
    githubId = 10913120;
  };
  djwf = {
    name = "David J. Weller-Fahy";
    email = "dave@weller-fahy.com";

    github = "djwf";
    githubId = 73162;
  };
  dkabot = {
    name = "Naomi Morse";
    email = "dkabot@dkabot.com";

    github = "dkabot";
    githubId = 1316469;
  };
  dlesl = {
    name = "David Leslie";
    email = "dlesl@dlesl.com";

    github = "dlesl";
    githubId = 28980797;
  };
  dlip = {
    name = "Dane Lipscombe";
    email = "dane@lipscombe.com.au";

    github = "dlip";
    githubId = 283316;
  };
  dmalikov = {
    name = "Dmitry Malikov";
    email = "malikov.d.y@gmail.com";

    github = "dmalikov";
    githubId = 997543;
  };
  DmitryTsygankov = {
    name = "Dmitry Tsygankov";
    email = "dmitry.tsygankov@gmail.com";

    github = "DmitryTsygankov";
    githubId = 425354;
  };
  dmjio = {
    name = "David Johnson";
    email = "djohnson.m@gmail.com";

    github = "dmjio";
    githubId = 875324;
  };
  dmrauh = {
    name = "Dominik Michael Rauh";
    email = "dmrauh@posteo.de";

    github = "dmrauh";
    githubId = 37698547;
  };
  dmvianna = {
    name = "Daniel Vianna";
    email = "dmlvianna@gmail.com";

    github = "dmvianna";
    githubId = 1708810;
  };
  dnr = {
    name = "David Reiss";
    email = "dnr@dnr.im";

    github = "dnr";
    githubId = 466723;
  };
  dochang = {
    name = "Desmond O. Chang";
    email = "dochang@gmail.com";

    github = "dochang";
    githubId = 129093;
  };
  domenkozar = {
    name = "Domen Kozar";
    email = "domen@dev.si";

    github = "domenkozar";
    githubId = 126339;
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
    name = "Dominik Honnef";
    email = "dominik@honnef.co";

    github = "dominikh";
    githubId = 39825;
  };
  doronbehar = {
    name = "Doron Behar";
    email = "me@doronbehar.com";

    github = "doronbehar";
    githubId = 10998835;
  };
  dotlambda = {
    name = "Robert Schütz";
    email = "rschuetz17@gmail.com";

    matrix = "@robert:funklause.de";
    github = "dotlambda";
    githubId = 6806011;
  };
  dottedmag = {
    name = "Misha Gusarov";
    email = "dottedmag@dottedmag.net";

    github = "dottedmag";
    githubId = 16120;
    keys = [{
      fingerprint = "A8DF 1326 9E5D 9A38 E57C  FAC2 9D20 F650 3E33 8888";
    }];
  };
  doublec = {
    name = "Chris Double";
    email = "chris.double@double.co.nz";

    github = "doublec";
    githubId = 16599;
  };
  dpaetzel = {
    name = "David Pätzel";
    email = "david.paetzel@posteo.de";

    github = "dpaetzel";
    githubId = 974130;
  };
  dpausp = {
    name = "Tobias Stenzel";
    email = "dpausp@posteo.de";

    github = "dpausp";
    githubId = 1965950;
    keys = [{
      fingerprint = "4749 0887 CF3B 85A1 6355  C671 78C7 DD40 DF23 FB16";
    }];
  };
  DPDmancul = {
    name = "Davide Peressoni";
    email = "davide.peressoni@tuta.io";

    matrix = "@dpd-:matrix.org";
    github = "DPDmancul";
    githubId = 3186857;
  };
  dpercy = {
    name = "David Percy";
    email = "dpercy@dpercy.dev";

    github = "dpercy";
    githubId = 349909;
  };
  dpflug = {
    name = "David Pflug";
    email = "david@pflug.email";

    github = "dpflug";
    githubId = 108501;
  };
  dramaturg = {
    name = "Sebastian Krohn";
    email = "seb@ds.ag";

    github = "dramaturg";
    githubId = 472846;
  };
  drets = {
    name = "Dmytro Rets";
    email = "dmitryrets@gmail.com";

    github = "drets";
    githubId = 6199462;
  };
  drewrisinger = {
    name = "Drew Risinger";
    email = "drisinger+nixpkgs@gmail.com";

    github = "drewrisinger";
    githubId = 10198051;
  };
  dritter = {
    name = "Dominik Ritter";
    email = "dritter03@googlemail.com";

    github = "dritter";
    githubId = 1544760;
  };
  drperceptron = {
    name = "Dr Perceptron";
    email = "92106371+drperceptron@users.noreply.github.com";

    github = "drperceptron";
    githubId = 92106371;
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
    name = "Jakob Neufeld";
    email = "jakob@mast3rsoft.com";

    github = "jakobneufeld";
    githubId = 24791219;
  };
  dsalaza4 = {
    name = "Daniel Salazar";
    email = "podany270895@gmail.com";

    github = "dsalaza4";
    githubId = 11205987;
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
    name = "David Sferruzza";
    email = "david.sferruzza@gmail.com";

    github = "dsferruzza";
    githubId = 1931963;
  };
  dtzWill = {
    name = "Will Dietz";
    email = "w@wdtz.org";

    github = "dtzWill";
    githubId = 817330;
    keys = [{
      fingerprint = "389A 78CB CD88 5E0C 4701  DEB9 FD42 C7D0 D414 94C8";
    }];
  };
  dukc = {
    name = "Ate Eskola";
    email = "ajieskola@gmail.com";

    github = "dukc";
    githubId = 24233408;
  };
  dump_stack = {
    name = "Mikhail Klementev";
    email = "root@dumpstack.io";

    github = "jollheef";
    githubId = 1749762;
    keys = [{
      fingerprint = "5DD7 C6F6 0630 F08E DAE7  4711 1525 585D 1B43 C62A";
    }];
  };
  dwarfmaster = {
    name = "Luc Chabassier";
    email = "nixpkgs@dwarfmaster.net";

    github = "dwarfmaster";
    githubId = 2025623;
  };
  dxf = {
    name = "Ding Xiang Fei";
    email = "dingxiangfei2009@gmail.com";

    github = "dingxiangfei2009";
    githubId = 6884440;
  };
  dysinger = {
    name = "Tim Dysinger";
    email = "tim@dysinger.net";

    github = "dysinger";
    githubId = 447;
  };
  dywedir = {
    name = "Vladyslav M.";
    email = "dywedir@gra.red";

    matrix = "@dywedir:matrix.org";
    github = "dywedir";
    githubId = 399312;
  };
  dzabraev = {
    name = "Maksim Dzabraev";
    email = "dzabraew@gmail.com";

    github = "dzabraev";
    githubId = 15128988;
  };
  e1mo = {
    name = "Moritz Fromm";
    email = "nixpkgs@e1mo.de";

    matrix = "@e1mo:chaos.jetzt";
    github = "e1mo";
    githubId = 61651268;
    keys = [{
      fingerprint = "67BE E563 43B6 420D 550E  DF2A 6D61 7FD0 A85B AADA";
    }];
  };
  eadwu = {
    name = "Edmund Wu";
    email = "edmund.wu@protonmail.com";

    github = "eadwu";
    githubId = 22758444;
  };
  ealasu = {
    name = "Emanuel Alasu";
    email = "emanuel.alasu@gmail.com";

    github = "ealasu";
    githubId = 1362096;
  };
  eamsden = {
    name = "Edward Amsden";
    email = "edward@blackriversoft.com";

    github = "eamsden";
    githubId = 54573;
  };
  earldouglas = {
    name = "James Earl Douglas";
    email = "james@earldouglas.com";

    github = "earldouglas";
    githubId = 424946;
  };
  ebbertd = {
    name = "Daniel Ebbert";
    email = "daniel@ebbert.nrw";

    github = "ebbertd";
    githubId = 20522234;
    keys = [{
      fingerprint = "E765 FCA3 D9BF 7FDB 856E  AD73 47BC 1559 27CB B9C7";
    }];
  };
  ebzzry = {
    name = "Rommel Martinez";
    email = "ebzzry@ebzzry.io";

    github = "ebzzry";
    githubId = 7875;
  };
  edanaher = {
    name = "Evan Danaher";
    email = "nixos@edanaher.net";

    github = "edanaher";
    githubId = 984691;
  };
  edbentley = {
    name = "Ed Bentley";
    email = "hello@edbentley.dev";

    github = "edbentley";
    githubId = 15923595;
  };
  edcragg = {
    name = "Ed Cragg";
    email = "ed.cragg@eipi.xyz";

    github = "nuxeh";
    githubId = 1516017;
  };
  edef = {
    name = "edef";
    email = "edef@edef.eu";

    github = "edef1c";
    githubId = 50854;
  };
  ederoyd46 = {
    name = "Matthew Brown";
    email = "matt@ederoyd.co.uk";

    github = "ederoyd46";
    githubId = 119483;
  };
  edlimerkaj = {
    name = "Edli Merkaj";
    email = "edli.merkaj@identinet.io";

    github = "edlimerkaj";
    githubId = 71988351;
  };
  edrex = {
    name = "Eric Drechsel";
    email = "ericdrex@gmail.com";

    matrix = "@edrex:matrix.org";
    github = "edrex";
    githubId = 14615;
    keys = [{
      fingerprint = "AC47 2CCC 9867 4644 A9CF  EB28 1C5C 1ED0 9F66 6824";
    }];
  };
  eduarrrd = {
    name = "Eduard Bachmakov";
    email = "e.bachmakov@gmail.com";

    github = "eduarrrd";
    githubId = 1181393;
  };
  edude03 = {
    name = "Michael Francis";
    email = "michael@melenion.com";

    github = "edude03";
    githubId = 494483;
  };
  edwtjo = {
    name = "Edward Tjörnhammar";
    email = "ed@cflags.cc";

    github = "edwtjo";
    githubId = 54799;
  };
  eelco = {
    name = "Eelco Dolstra";
    email = "edolstra+nixpkgs@gmail.com";

    github = "edolstra";
    githubId = 1148549;
  };
  ehegnes = {
    name = "Eric Hegnes";
    email = "eric.hegnes@gmail.com";

    github = "ehegnes";
    githubId = 884970;
  };
  ehllie = {
    name = "Elizabeth Paź";
    email = "me@ehllie.xyz";

    github = "ehllie";
    githubId = 20847625;
  };
  ehmry = {
    name = "Emery Hemingway";
    email = "ehmry@posteo.net";

    github = "ehmry";
    githubId = 537775;
  };
  eigengrau = {
    name = "Sebastian Reuße";
    email = "seb@schattenkopie.de";

    github = "eigengrau";
    githubId = 4939947;
  };
  eikek = {
    name = "Eike Kettner";
    email = "eike.kettner@posteo.de";

    github = "eikek";
    githubId = 701128;
  };
  ekleog = {
    name = "Leo Gaspard";
    email = "leo@gaspard.io";

    matrix = "@leo:gaspard.ninja";
    github = "Ekleog";
    githubId = 411447;
  };
  elasticdog = {
    name = "Aaron Bull Schaefer";
    email = "aaron@elasticdog.com";

    github = "elasticdog";
    githubId = 4742;
  };
  elatov = {
    name = "Karim Elatov";
    email = "elatov@gmail.com";

    github = "elatov";
    githubId = 7494394;
  };
  eleanor = {
    name = "Dejan Lukan";
    email = "dejan@proteansec.com";

    github = "proteansec";
    githubId = 1753498;
  };
  electrified = {
    name = "Ed Brindley";
    email = "ed@maidavale.org";

    github = "electrified";
    githubId = 103082;
  };
  eliasp = {
    name = "Elias Probst";
    email = "mail@eliasprobst.eu";

    matrix = "@eliasp:kde.org";
    github = "eliasp";
    githubId = 48491;
  };
  elijahcaine = {
    name = "Elijah Caine";
    email = "elijahcainemv@gmail.com";

    github = "pop";
    githubId = 1897147;
  };
  Elinvention = {
    name = "Elia Argentieri";
    email = "elia@elinvention.ovh";

    github = "Elinvention";
    githubId = 5737945;
  };
  elitak = {
    name = "Eric Litak";
    email = "elitak@gmail.com";

    github = "elitak";
    githubId = 769073;
  };
  elizagamedev = {
    name = "Eliza Velasquez";
    email = "eliza@eliza.sh";

    github = "elizagamedev";
    githubId = 4576666;
  };
  elkowar = {
    name = "Leon Kowarschick";
    email = "thereal.elkowar@gmail.com";

    github = "elkowar";
    githubId = 5300871;
  };
  elliot = {
    name = "Elliot Xu";
    email = "hack00mind@gmail.com";

    github = "Eliot00";
    githubId = 18375468;
  };
  elliottslaughter = {
    name = "Elliott Slaughter";
    email = "elliottslaughter@gmail.com";

    github = "elliottslaughter";
    githubId = 3129;
  };
  elliottvillars = {
    name = "Elliott Villars";
    email = "elliottvillars@gmail.com";

    github = "elliottvillars";
    githubId = 48104179;
  };
  ellis = {
    name = "Ellis Whitehead";
    email = "nixos@ellisw.net";

    github = "ellis";
    githubId = 97852;
  };
  elohmeier = {
    name = "Enno Lohmeier";
    email = "elo-nixos@nerdworks.de";

    github = "elohmeier";
    githubId = 2536303;
  };
  elvishjerricco = {
    name = "Will Fancher";
    email = "elvishjerricco@gmail.com";

    github = "ElvishJerricco";
    githubId = 1365692;
  };
  emantor = {
    name = "Rouven Czerwinski";
    email = "rouven+nixos@czerwinskis.de";

    github = "Emantor";
    githubId = 934284;
  };
  emattiza = {
    name = "Evan Mattiza";
    email = "nix@mattiza.dev";

    github = "emattiza";
    githubId = 11719476;
  };
  embr = {
    name = "embr";
    email = "hi@liclac.eu";

    github = "liclac";
    githubId = 428026;
  };
  emily = {
    name = "Emily";
    email = "nixpkgs@emily.moe";

    github = "emilazy";
    githubId = 18535642;
  };
  emilytrau = {
    name = "Emily Trau";
    email = "nix@angus.ws";

    github = "emilytrau";
    githubId = 13267947;
  };
  emmabastas = {
    name = "Emma Bastås";
    email = "emma.bastas@protonmail.com";

    matrix = "@emmabastas:matrix.org";
    github = "emmabastas";
    githubId = 22533224;
  };
  emmanuelrosa = {
    name = "Emmanuel Rosa";
    email = "emmanuelrosa@protonmail.com";

    matrix = "@emmanuelrosa:matrix.org";
    github = "emmanuelrosa";
    githubId = 13485450;
  };
  emptyflask = {
    name = "Jon Roberts";
    email = "jon@emptyflask.dev";

    github = "emptyflask";
    githubId = 28287;
  };
  enderger = {
    name = "Daniel";
    email = "endergeryt@gmail.com";

    github = "enderger";
    githubId = 36283171;
  };
  endgame = {
    name = "Jack Kelly";
    email = "jack@jackkelly.name";

    github = "endgame";
    githubId = 231483;
  };
  endocrimes = {
    name = "Danielle Lancashire";
    email = "dani@builds.terrible.systems";

    github = "endocrimes";
    githubId = 1330683;
  };
  enorris = {
    name = "Eric Norris";
    email = "erictnorris@gmail.com";

    github = "ericnorris";
    githubId = 1906605;
  };
  Enteee = {
    name = "Ente";
    email = "nix@duckpond.ch";

    github = "Enteee";
    githubId = 5493775;
  };
  Enzime = {
    name = "Michael Hoang";
    email = "enzime@users.noreply.github.com";

    github = "Enzime";
    githubId = 10492681;
  };
  eonpatapon = {
    name = "Jean-Philippe Braun";
    email = "eon@patapon.info";

    github = "eonpatapon";
    githubId = 418227;
  };
  eperuffo = {
    name = "Emanuele Peruffo";
    email = "info@emanueleperuffo.com";

    github = "emanueleperuffo";
    githubId = 5085029;
  };
  equirosa = {
    name = "Eduardo Quiros";
    email = "eduardo@eduardoquiros.com";

    github = "equirosa";
    githubId = 39096810;
  };
  eqyiel = {
    name = "Ruben Maher";
    email = "ruben@maher.fyi";

    github = "eqyiel";
    githubId = 3422442;
  };
  eraserhd = {
    name = "Jason Felice";
    email = "jason.m.felice@gmail.com";

    github = "eraserhd";
    githubId = 147284;
  };
  ercao = {
    name = "ercao";
    email = "vip@ercao.cn";

    github = "ercao";
    githubId = 51725284;
    keys = [{
      fingerprint = "F3B0 36F7 B0CB 0964 3C12  D3C7 FFAB D125 7ECF 0889";
    }];
  };
  erdnaxe = {
    name = "Alexandre Iooss";
    email = "erdnaxe@crans.org";

    github = "erdnaxe";
    githubId = 2663216;
    keys = [{
      fingerprint = "2D37 1AD2 7E2B BC77 97E1  B759 6C79 278F 3FCD CC02";
    }];
  };
  ereslibre = {
    name = "Rafael Fernández López";
    email = "ereslibre@ereslibre.es";

    matrix = "@ereslibre:matrix.org";
    github = "ereslibre";
    githubId = 8706;
  };
  ericbmerritt = {
    name = "Eric Merritt";
    email = "eric@afiniate.com";

    github = "ericbmerritt";
    githubId = 4828;
  };
  ericdallo = {
    name = "Eric Dallo";
    email = "ercdll1337@gmail.com";

    github = "ericdallo";
    githubId = 7820865;
  };
  ericsagnes = {
    name = "Eric Sagnes";
    email = "eric.sagnes@gmail.com";

    github = "ericsagnes";
    githubId = 367880;
  };
  ericson2314 = {
    name = "John Ericson";
    email = "John.Ericson@Obsidian.Systems";

    matrix = "@ericson2314:matrix.org";
    github = "Ericson2314";
    githubId = 1055245;
  };
  erictapen = {
    name = "Kerstin Humm";
    email = "kerstin@erictapen.name";

    github = "erictapen";
    githubId = 11532355;
    keys = [{
      fingerprint = "F178 B4B4 6165 6D1B 7C15  B55D 4029 3358 C7B9 326B";
    }];
  };
  erikarvstedt = {
    name = "Erik Arvstedt";
    email = "erik.arvstedt@gmail.com";

    matrix = "@erikarvstedt:matrix.org";
    github = "erikarvstedt";
    githubId = 36110478;
  };
  erikbackman = {
    name = "Erik Backman";
    email = "contact@ebackman.net";

    github = "erikbackman";
    githubId = 46724898;
  };
  erikryb = {
    name = "Erik Rybakken";
    email = "erik.rybakken@math.ntnu.no";

    github = "erikryb";
    githubId = 3787281;
  };
  erin = {
    name = "Erin van der Veen";
    email = "erin@erinvanderveen.nl";

    github = "ErinvanderVeen";
    githubId = 10973664;
  };
  erosennin = {
    name = "Andrey Golovizin";
    email = "ag@sologoc.com";

    github = "erosennin";
    githubId = 1583484;
  };
  ersin = {
    name = "Ersin Akinci";
    email = "me@ersinakinci.com";

    github = "ersinakinci";
    githubId = 5427394;
  };
  ertes = {
    name = "Ertugrul Söylemez";
    email = "esz@posteo.de";

    github = "ertes";
    githubId = 1855930;
  };
  esclear = {
    name = "Daniel Albert";
    email = "esclear@users.noreply.github.com";

    github = "esclear";
    githubId = 7432848;
  };
  eskytthe = {
    name = "Erik Skytthe";
    email = "eskytthe@gmail.com";

    github = "eskytthe";
    githubId = 2544204;
  };
  ethancedwards8 = {
    name = "Ethan Carter Edwards";
    email = "ethan@ethancedwards.com";

    github = "ethancedwards8";
    githubId = 60861925;
    keys = [{
      fingerprint = "0E69 0F46 3457 D812 3387  C978 F93D DAFA 26EF 2458";
    }];
  };
  ethercrow = {
    name = "Dmitry Ivanov";
    email = "ethercrow@gmail.com";

    github = "ethercrow";
    githubId = 222467;
  };
  ethindp = {
    name = "Ethin Probst";
    email = "harlydavidsen@gmail.com";

    matrix = "@ethindp:the-gdn.net";
    github = "ethindp";
    githubId = 8030501;
  };
  Etjean = {
    name = "Etienne Jean";
    email = "et.jean@outlook.fr";

    github = "Etjean";
    githubId = 32169529;
  };
  etu = {
    name = "Elis Hirwing";
    email = "elis@hirwing.se";

    matrix = "@etu:semi.social";
    github = "etu";
    githubId = 461970;
    keys = [{
      fingerprint = "67FE 98F2 8C44 CF22 1828  E12F D57E FA62 5C9A 925F";
    }];
  };
  euank = {
    name = "Euan Kemp";
    email = "euank-nixpkg@euank.com";

    github = "euank";
    githubId = 2147649;
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
    name = "Evan Stoll";
    email = "evanjsx@gmail.com";

    github = "evanjs";
    githubId = 1847524;
  };
  evax = {
    name = "evax";
    email = "nixos@evax.fr";

    github = "evax";
    githubId = 599997;
  };
  evck = {
    name = "Eric Evenchick";
    email = "eric@evenchick.com";

    github = "ericevenchick";
    githubId = 195032;
  };
  evenbrenden = {
    name = "Even Brenden";
    email = "evenbrenden@gmail.com";

    github = "evenbrenden";
    githubId = 2512008;
  };
  evils = {
    name = "Evils";
    email = "evils.devils@protonmail.com";

    matrix = "@evils:nixos.dev";
    github = "evils";
    githubId = 30512529;
  };
  ewok = {
    name = "Artur Taranchiev";
    email = "ewok@ewok.ru";

    github = "ewok";
    githubId = 454695;
  };
  exarkun = {
    name = "Jean-Paul Calderone";
    email = "exarkun@twistedmatrix.com";

    github = "exarkun";
    githubId = 254565;
  };
  exfalso = {
    name = "Andras Slemmer";
    email = "0slemi0@gmail.com";

    github = "exFalso";
    githubId = 1042674;
  };
  exi = {
    name = "Reno Reckling";
    email = "nixos@reckling.org";

    github = "exi";
    githubId = 449463;
  };
  exlevan = {
    name = "Alexey Levan";
    email = "exlevan@gmail.com";

    github = "exlevan";
    githubId = 873530;
  };
  expipiplus1 = {
    name = "Ellie Hermaszewska";
    email = "nix@monoid.al";

    matrix = "@ellie:monoid.al";
    github = "expipiplus1";
    githubId = 857308;
    keys = [{
      fingerprint = "FC1D 3E4F CBCA 80DF E870  6397 C811 6E3A 0C1C A76A";
    }];
  };
  extends = {
    name = "Vincent VILLIAUMEY";
    email = "sharosari@gmail.com";

    github = "ImExtends";
    githubId = 55919390;
  };
  eyjhb = {
    name = "eyJhb";
    email = "eyjhbb@gmail.com";

    matrix = "@eyjhb:eyjhb.dk";
    github = "eyJhb";
    githubId = 25955146;
  };
  f--t = {
    name = "f--t";
    email = "git@f-t.me";

    github = "f--t";
    githubId = 2817965;
  };
  f4814n = {
    name = "Fabian Geiselhart";
    email = "me@f4814n.de";

    github = "f4814";
    githubId = 11909469;
  };
  fab = {
    name = "Fabian Affolter";
    email = "mail@fabian-affolter.ch";

    matrix = "@fabaff:matrix.org";
    github = "fabaff";
    githubId = 116184;
    keys = [{
      fingerprint = "2F6C 930F D3C4 7E38 6AFA  4EB4 E23C D2DD 36A4 397F";
    }];
  };
  fabiangd = {
    name = "Fabian G. Dröge";
    email = "fabian.g.droege@gmail.com";

    github = "FabianGD";
    githubId = 40316600;
  };
  fabianhauser = {
    name = "Fabian Hauser";
    email = "fabian.nixos@fh2.ch";

    github = "fabianhauser";
    githubId = 368799;
    keys = [{
      fingerprint = "50B7 11F4 3DFD 2018 DCE6  E8D0 8A52 A140 BEBF 7D2C";
    }];
  };
  fabianhjr = {
    name = "Fabián Heredia Montiel";
    email = "fabianhjr@protonmail.com";

    github = "fabianhjr";
    githubId = 303897;
  };
  fadenb = {
    name = "Tristan Helmich";
    email = "tristan.helmich+nixos@gmail.com";

    github = "fadenb";
    githubId = 878822;
  };
  falsifian = {
    name = "James Cook";
    email = "james.cook@utoronto.ca";

    github = "falsifian";
    githubId = 225893;
  };
  farcaller = {
    name = "Vladimir Pouzanov";
    email = "farcaller@gmail.com";

    github = "farcaller";
    githubId = 693;
  };
  fare = {
    name = "Francois-Rene Rideau";
    email = "fahree@gmail.com";

    github = "fare";
    githubId = 8073;
  };
  farlion = {
    name = "Florian Peter";
    email = "florian.peter@gmx.at";

    github = "workflow";
    githubId = 1276854;
  };
  farnoy = {
    name = "Jakub Okoński";
    email = "jakub@okonski.org";

    github = "farnoy";
    githubId = 345808;
  };
  fbeffa = {
    name = "Federico Beffa";
    email = "beffa@fbengineering.ch";

    github = "fedeinthemix";
    githubId = 7670450;
  };
  fbergroth = {
    name = "Fredrik Bergroth";
    email = "fbergroth@gmail.com";

    github = "fbergroth";
    githubId = 1211003;
  };
  fbrs = {
    name = "Florian Beeres";
    email = "yuuki@protonmail.com";

    github = "cideM";
    githubId = 4246921;
  };
  fdns = {
    name = "Felipe Espinoza";
    email = "fdns02@gmail.com";

    github = "fdns";
    githubId = 541748;
  };
  federicoschonborn = {
    name = "Federico Damián Schonborn";
    email = "fdschonborn@gmail.com";

    matrix = "@FedericoDSchonborn:matrix.org";
    github = "FedericoSchonborn";
    githubId = 62166915;
    keys = [{
      fingerprint = "517A 8A6A 09CA A11C 9667  CEE3 193F 70F1 5C9A B0A0";
    }];
  };
  fedx-sudo = {
    name = "Fedx sudo";
    email = "fedx-sudo@pm.me";

    matrix = "fedx:matrix.org";
    github = "FedX-sudo";
    githubId = 66258975;
  };
  fee1-dead = {
    name = "Deadbeef";
    email = "ent3rm4n@gmail.com";

    github = "fee1-dead";
    githubId = 43851243;
  };
  fehnomenal = {
    name = "Andreas Fehn";
    email = "fehnomenal@fehn.systems";

    github = "fehnomenal";
    githubId = 9959940;
  };
  felipeqq2 = {
    name = "Felipe Silva";
    email = "nixpkgs@felipeqq2.rocks";

    matrix = "@felipeqq2:pub.solar";
    github = "felipeqq2";
    githubId = 71830138;
    keys = [{
      fingerprint = "F5F0 2BCE 3580 BF2B 707A  AA8C 2FD3 4A9E 2671 91B8";
    }];
  };
  felixscheinost = {
    name = "Felix Scheinost";
    email = "felix.scheinost@posteo.de";

    github = "felixscheinost";
    githubId = 31761492;
  };
  felixsinger = {
    name = "Felix Singer";
    email = "felixsinger@posteo.net";

    github = "felixsinger";
    githubId = 628359;
  };
  felschr = {
    name = "Felix Schröter";
    email = "dev@felschr.com";

    matrix = "@felschr:matrix.org";
    github = "felschr";
    githubId = 3314323;
    keys = [
      {
        fingerprint = "6AB3 7A28 5420 9A41 82D9  0068 910A CB9F 6BD2 6F58";
      }

      {
        fingerprint = "7E08 6842 0934 AA1D 6821  1F2A 671E 39E6 744C 807D";
      }
    ];
  };
  ffinkdevs = {
    name = "Fabian Fink";
    email = "fink@h0st.space";

    github = "ffinkdevs";
    githubId = 45924649;
  };
  fgaz = {
    name = "Francesco Gazzetta";
    email = "fgaz@fgaz.me";

    matrix = "@fgaz:matrix.org";
    github = "fgaz";
    githubId = 8182846;
  };
  figsoda = {
    name = "figsoda";
    email = "figsoda@pm.me";

    matrix = "@figsoda:matrix.org";
    github = "figsoda";
    githubId = 40620903;
  };
  fionera = {
    name = "Tim Windelschmidt";
    email = "nix@fionera.de";

    github = "fionera";
    githubId = 5741401;
  };
  firefly-cpp = {
    name = "Iztok Fister Jr.";
    email = "iztok@iztok-jr-fister.eu";

    github = "firefly-cpp";
    githubId = 1633361;
  };
  FireyFly = {
    name = "Jonas Höglund";
    email = "nix@firefly.nu";

    github = "FireyFly";
    githubId = 415760;
  };
  fishi0x01 = {
    name = "Karl Fischer";
    email = "fishi0x01@gmail.com";

    github = "fishi0x01";
    githubId = 10799507;
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
    name = "Sebastian Neubauer";
    email = "flakebi@t-online.de";

    github = "Flakebi";
    githubId = 6499211;
    keys = [{
      fingerprint = "2F93 661D AC17 EA98 A104  F780 ECC7 55EE 583C 1672";
    }];
  };
  fleaz = {
    name = "Felix Breidenstein";
    email = "mail@felixbreidenstein.de";

    matrix = "@fleaz:rainbownerds.de";
    github = "fleaz";
    githubId = 2489598;
  };
  flexagoon = {
    name = "Pavel Zolotarevskiy";
    email = "flexagoon@pm.me";

    github = "flexagoon";
    githubId = 66178592;
  };
  fliegendewurst = {
    name = "Arne Keller";
    email = "arne.keller@posteo.de";

    github = "FliegendeWurst";
    githubId = 12560461;
  };
  flokli = {
    name = "Florian Klink";
    email = "flokli@flokli.de";

    github = "flokli";
    githubId = 183879;
  };
  florentc = {
    name = "Florent Ch.";
    email = "florentc@users.noreply.github.com";

    github = "florentc";
    githubId = 1149048;
  };
  FlorianFranzen = {
    name = "Florian Franzen";
    email = "Florian.Franzen@gmail.com";

    github = "FlorianFranzen";
    githubId = 781077;
  };
  florianjacob = {
    name = "Florian Jacob";
    email = "projects+nixos@florianjacob.de";

    github = "florianjacob";
    githubId = 1109959;
  };
  flosse = {
    name = "Markus Kohlhase";
    email = "mail@markus-kohlhase.de";

    github = "flosse";
    githubId = 276043;
  };
  fluffynukeit = {
    name = "Daniel Austin";
    email = "dan@fluffynukeit.com";

    github = "fluffynukeit";
    githubId = 844574;
  };
  flyfloh = {
    name = "Florian Pester";
    email = "nix@halbmastwurf.de";

    github = "flyfloh";
    githubId = 74379;
  };
  fmoda3 = {
    name = "Frank Moda III";
    email = "fmoda3@mac.com";

    github = "fmoda3";
    githubId = 1746471;
  };
  fmthoma = {
    name = "Franz Thoma";
    email = "f.m.thoma@googlemail.com";

    github = "fmthoma";
    githubId = 5918766;
  };
  foo-dogsquared = {
    name = "Gabriel Arazas";
    email = "foo.dogsquared@gmail.com";

    github = "foo-dogsquared";
    githubId = 34962634;
  };
  fooker = {
    name = "Dustin Frisch";
    email = "fooker@lab.sh";

    github = "fooker";
    githubId = 405105;
  };
  foolnotion = {
    name = "Bogdan Burlacu";
    email = "bogdan.burlacu@pm.me";

    github = "foolnotion";
    githubId = 844222;
    keys = [{
      fingerprint = "B722 6464 838F 8BDB 2BEA  C8C8 5B0E FDDF BA81 6105";
    }];
  };
  forkk = {
    name = "Andrew Okin";
    email = "forkk@forkk.net";

    github = "Forkk";
    githubId = 1300078;
  };
  fornever = {
    name = "Friedrich von Never";
    email = "friedrich@fornever.me";

    github = "ForNeVeR";
    githubId = 92793;
  };
  fortuneteller2k = {
    name = "fortuneteller2k";
    email = "lythe1107@gmail.com";

    matrix = "@fortuneteller2k:matrix.org";
    github = "fortuneteller2k";
    githubId = 20619776;
  };
  fpletz = {
    name = "Franz Pletz";
    email = "fpletz@fnordicwalking.de";

    github = "fpletz";
    githubId = 114159;
    keys = [{
      fingerprint = "8A39 615D CE78 AF08 2E23  F303 846F DED7 7926 17B4";
    }];
  };
  fps = {
    name = "Florian Paul Schmidt";
    email = "mista.tapas@gmx.net";

    github = "fps";
    githubId = 84968;
  };
  fragamus = {
    name = "Michael Gough";
    email = "innovative.engineer@gmail.com";

    github = "fragamus";
    githubId = 119691;
  };
  freax13 = {
    name = "Tom Dohrmann";
    email = "erbse.13@gmx.de";

    github = "Freax13";
    githubId = 14952658;
  };
  fredeb = {
    name = "Frede Emil";
    email = "im@fredeb.dev";

    github = "FredeEB";
    githubId = 7551358;
  };
  freezeboy = {
    name = "freezeboy";
    email = "freezeboy@users.noreply.github.com";

    github = "freezeboy";
    githubId = 13279982;
  };
  Fresheyeball = {
    name = "Isaac Shapira";
    email = "fresheyeball@gmail.com";

    github = "Fresheyeball";
    githubId = 609279;
  };
  fridh = {
    name = "Frederik Rietdijk";
    email = "fridh@fridh.nl";

    github = "FRidh";
    githubId = 2129135;
  };
  friedelino = {
    name = "Frido Friedemann";
    email = "friede.mann@posteo.de";

    github = "friedelino";
    githubId = 46672819;
  };
  frlan = {
    name = "Frank Lanitz";
    email = "frank@frank.uvena.de";

    github = "frlan";
    githubId = 1010248;
  };
  fro_ozen = {
    name = "fro_ozen";
    email = "fro_ozen@gmx.de";

    github = "froozen";
    githubId = 1943632;
  };
  frogamic = {
    name = "Dominic Shelton";
    email = "frogamic@protonmail.com";

    github = "frogamic";
    githubId = 10263813;
  };
  frontsideair = {
    name = "Fatih Altinok";
    email = "photonia@gmail.com";

    github = "frontsideair";
    githubId = 868283;
  };
  Frostman = {
    name = "Sergei Lukianov";
    email = "me@slukjanov.name";

    github = "Frostman";
    githubId = 134872;
  };
  fstamour = {
    name = "Francis St-Amour";
    email = "fr.st-amour@gmail.com";

    github = "fstamour";
    githubId = 2881922;
  };
  ftrvxmtrx = {
    name = "Sigrid Solveig Haflínudóttir";
    email = "ftrvxmtrx@gmail.com";

    github = "ftrvxmtrx";
    githubId = 248148;
  };
  fuerbringer = {
    name = "Severin Fürbringer";
    email = "severin@fuerbringer.info";

    github = "fuerbringer";
    githubId = 10528737;
  };
  fufexan = {
    name = "Fufezan Mihai";
    email = "fufexan@protonmail.com";

    github = "fufexan";
    githubId = 36706276;
  };
  fusion809 = {
    name = "Brenton Horne";
    email = "brentonhorne77@gmail.com";

    github = "fusion809";
    githubId = 4717341;
  };
  fuuzetsu = {
    name = "Mateusz Kowalczyk";
    email = "fuuzetsu@fuuzetsu.co.uk";

    github = "Fuuzetsu";
    githubId = 893115;
  };
  fuzen = {
    name = "Fuzen";
    email = "me@fuzen.cafe";

    github = "Fuzen-py";
    githubId = 17859309;
  };
  fxfactorial = {
    name = "Edgar Aroutiounian";
    email = "edgar.factorial@gmail.com";

    github = "fxfactorial";
    githubId = 3036816;
  };
  fzakaria = {
    name = "Farid Zakaria";
    email = "farid.m.zakaria@gmail.com";

    matrix = "@fzakaria:matrix.org";
    github = "fzakaria";
    githubId = 605070;
  };
  gabesoft = {
    name = "Gabriel Adomnicai";
    email = "gabesoft@gmail.com";

    github = "gabesoft";
    githubId = 606000;
  };
  Gabriel439 = {
    name = "Gabriel Gonzalez";
    email = "Gabriel439@gmail.com";

    github = "Gabriella439";
    githubId = 1313787;
  };
  gador = {
    name = "Florian Brandes";
    email = "florian.brandes@posteo.de";

    github = "gador";
    githubId = 1883533;
    keys = [{
      fingerprint = "0200 3EF8 8D2B CF2D 8F00  FFDC BBB3 E40E 5379 7FD9";
    }];
  };
  GaetanLepage = {
    name = "Gaetan Lepage";
    email = "gaetan@glepage.com";

    github = "GaetanLepage";
    githubId = 33058747;
  };
  gal_bolle = {
    name = "Florent Becker";
    email = "florent.becker@ens-lyon.org";

    github = "FlorentBecker";
    githubId = 7047019;
  };
  galagora = {
    name = "Alwanga Oyango";
    email = "lightningstrikeiv@gmail.com";

    github = "Galagora";
    githubId = 45048741;
  };
  gamb = {
    name = "Adam Gamble";
    email = "adam.gamble@pm.me";

    github = "gamb";
    githubId = 293586;
  };
  garbas = {
    name = "Rok Garbas";
    email = "rok@garbas.si";

    github = "garbas";
    githubId = 20208;
  };
  gardspirito = {
    name = "gardspirito";
    email = "nyxoroso@gmail.com";

    github = "gardspirito";
    githubId = 29687558;
  };
  garrison = {
    name = "Jim Garrison";
    email = "jim@garrison.cc";

    github = "garrison";
    githubId = 91987;
  };
  gavin = {
    name = "Gavin Rogers";
    email = "gavin.rogers@holo.host";

    github = "gavinrogers";
    githubId = 2430469;
  };
  gazally = {
    name = "Gemini Lasswell";
    email = "gazally@runbox.com";

    github = "gazally";
    githubId = 16470252;
  };
  gbpdt = {
    name = "Graham Bennett";
    email = "nix@pdtpartners.com";

    github = "gbpdt";
    githubId = 25106405;
  };
  gbtb = {
    name = "gbtb";
    email = "goodbetterthebeast3@gmail.com";

    github = "gbtb";
    githubId = 37017396;
  };
  gdamjan = {
    name = "Damjan Georgievski";
    email = "gdamjan@gmail.com";

    matrix = "@gdamjan:spodeli.org";
    github = "gdamjan";
    githubId = 81654;
  };
  gdinh = {
    name = "Grace Dinh";
    email = "nix@contact.dinh.ai";

    github = "gdinh";
    githubId = 34658064;
  };
  gebner = {
    name = "Gabriel Ebner";
    email = "gebner@gebner.org";

    github = "gebner";
    githubId = 313929;
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
    name = "George Whewell";
    email = "georgerw@gmail.com";

    github = "georgewhewell";
    githubId = 1176131;
  };
  georgyo = {
    name = "George Shammas";
    email = "george@shamm.as";

    github = "georgyo";
    githubId = 19374;
    keys = [{
      fingerprint = "D0CF 440A A703 E0F9 73CB  A078 82BB 70D5 41AE 2DB4";
    }];
  };
  gerschtli = {
    name = "Tobias Happ";
    email = "tobias.happ@gmx.de";

    github = "Gerschtli";
    githubId = 10353047;
  };
  gfrascadorio = {
    name = "Galois";
    email = "gfrascadorio@tutanota.com";

    github = "gfrascadorio";
    githubId = 37602871;
  };
  ggpeti = {
    name = "Peter Ferenczy";
    email = "ggpeti@gmail.com";

    matrix = "@ggpeti:ggpeti.com";
    github = "ggPeti";
    githubId = 3217744;
  };
  ghostbuster91 = {
    name = "Kasper Kondzielski";
    email = "kghost0@gmail.com";

    github = "ghostbuster91";
    githubId = 5662622;
  };
  ghuntley = {
    name = "Geoffrey Huntley";
    email = "ghuntley@ghuntley.com";

    github = "ghuntley";
    githubId = 127353;
  };
  gila = {
    name = "Jeffry Molanus";
    email = "jeffry.molanus@gmail.com";

    github = "gila";
    githubId = 15957973;
  };
  gilice = {
    name = "gilice";
    email = "gilice@proton.me";

    github = "gilice";
    githubId = 104317939;
  };
  gilligan = {
    name = "Tobias Pflug";
    email = "tobias.pflug@gmail.com";

    github = "gilligan";
    githubId = 27668;
  };
  gin66 = {
    name = "Jochen Kiemes";
    email = "jochen@kiemes.de";

    github = "gin66";
    githubId = 5549373;
  };
  giogadi = {
    name = "Luis G. Torres";
    email = "lgtorres42@gmail.com";

    github = "giogadi";
    githubId = 1713676;
  };
  GKasparov = {
    name = "Mazen Zahr";
    email = "mizozahr@gmail.com";

    github = "GKasparov";
    githubId = 60962839;
  };
  gleber = {
    name = "Gleb Peregud";
    email = "gleber.p@gmail.com";

    github = "gleber";
    githubId = 33185;
  };
  glenns = {
    name = "Glenn Searby";
    email = "glenn.searby@gmail.com";

    github = "GlennS";
    githubId = 615606;
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
    name = "Craig Hall";
    email = "ch9871@gmail.com";

    github = "gloaming";
    githubId = 10156748;
  };
  globin = {
    name = "Robin Gloster";
    email = "mail@glob.in";

    github = "globin";
    githubId = 1447245;
  };
  gnxlxnxx = {
    name = "Roman Kretschmer";
    email = "gnxlxnxx@web.de";

    github = "gnxlxnxx";
    githubId = 25820499;
  };
  goertzenator = {
    name = "Daniel Goertzen";
    email = "daniel.goertzen@gmail.com";

    github = "goertzenator";
    githubId = 605072;
  };
  goibhniu = {
    name = "Cillian de Róiste";
    email = "cillian.deroiste@gmail.com";

    github = "cillianderoiste";
    githubId = 643494;
  };
  GoldsteinE = {
    name = "Maximilian Siling";
    email = "root@goldstein.rs";

    github = "GoldsteinE";
    githubId = 12019211;
    keys = [{
      fingerprint = "0BAF 2D87 CB43 746F 6237  2D78 DE60 31AB A0BB 269A";
    }];
  };
  Gonzih = {
    name = "Max Gonzih";
    email = "gonzih@gmail.com";

    github = "Gonzih";
    githubId = 266275;
  };
  goodrone = {
    name = "Andrew Trachenko";
    email = "goodrone@gmail.com";

    github = "goodrone";
    githubId = 1621335;
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
    name = "Godefroid Chapelle";
    email = "gotcha@bubblenet.be";

    github = "gotcha";
    githubId = 105204;
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
    name = "Guilherme Paixão";
    email = "me@guip.dev";

    github = "gp2112";
    githubId = 26512375;
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
    name = "isogram";
    email = "nixos-6c64ce18-bbbc-414f-8dcb-f9b6b47fe2bc@isopleth.org";

    github = "gpl";
    githubId = 39648069;
  };
  gpyh = {
    name = "Yacine Hmito";
    email = "yacine.hmito@gmail.com";

    github = "yacinehmito";
    githubId = 6893840;
  };
  graham33 = {
    name = "Graham Bennett";
    email = "graham@grahambennett.org";

    github = "graham33";
    githubId = 10908649;
  };
  grahamc = {
    name = "Graham Christensen";
    email = "graham@grahamc.com";

    github = "grahamc";
    githubId = 76716;
  };
  gravndal = {
    name = "Gaute Ravndal";
    email = "gaute.ravndal+nixos@gmail.com";

    github = "gravndal";
    githubId = 4656860;
  };
  graysonhead = {
    name = "Grayson Head";
    email = "grayson@graysonhead.net";

    github = "graysonhead";
    githubId = 6179496;
  };
  grburst = {
    name = "GRBurst";
    email = "GRBurst@protonmail.com";

    github = "GRBurst";
    githubId = 4647221;
    keys = [{
      fingerprint = "7FC7 98AB 390E 1646 ED4D  8F1F 797F 6238 68CD 00C2";
    }];
  };
  greizgh = {
    name = "greizgh";
    email = "greizgh@ephax.org";

    github = "greizgh";
    githubId = 1313624;
  };
  greydot = {
    name = "Lana Black";
    email = "lanablack@amok.cc";

    github = "greydot";
    githubId = 7385287;
  };
  gridaphobe = {
    name = "Eric Seidel";
    email = "eric@seidel.io";

    github = "gridaphobe";
    githubId = 201997;
  };
  grindhold = {
    name = "grindhold";
    email = "grindhold+nix@skarphed.org";

    github = "grindhold";
    githubId = 2592640;
  };
  grnnja = {
    name = "Prem Netsuwan";
    email = "grnnja@gmail.com";

    github = "grnnja";
    githubId = 31556469;
  };
  groodt = {
    name = "Greg Roodt";
    email = "groodt@gmail.com";

    github = "groodt";
    githubId = 343415;
  };
  gruve-p = {
    name = "gruve-p";
    email = "groestlcoin@gmail.com";

    github = "gruve-p";
    githubId = 11212268;
  };
  gschwartz = {
    name = "Gregory Schwartz";
    email = "gsch@pennmedicine.upenn.edu";

    github = "GregorySchwartz";
    githubId = 2490088;
  };
  gspia = {
    name = "gspia";
    email = "iahogsp@gmail.com";

    github = "gspia";
    githubId = 3320792;
  };
  gtrunsec = {
    name = "GuangTao Zhang";
    email = "gtrunsec@hardenedlinux.org";

    github = "GTrunSec";
    githubId = 21156405;
  };
  guibert = {
    name = "David Guibert";
    email = "david.guibert@gmail.com";

    github = "dguibert";
    githubId = 1178864;
  };
  guibou = {
    name = "Guillaume Bouchard";
    email = "guillaum.bouchard@gmail.com";

    github = "guibou";
    githubId = 9705357;
  };
  GuillaumeDesforges = {
    name = "Guillaume Desforges";
    email = "aceus02@gmail.com";

    github = "GuillaumeDesforges";
    githubId = 1882000;
  };
  guillaumekoenig = {
    name = "Guillaume Koenig";
    email = "guillaume.edward.koenig@gmail.com";

    github = "guillaumekoenig";
    githubId = 10654650;
  };
  guserav = {
    name = "guserav";
    email = "guserav@users.noreply.github.com";

    github = "guserav";
    githubId = 28863828;
  };
  guyonvarch = {
    name = "Joris Guyonvarch";
    email = "joris@guyonvarch.me";

    github = "guyonvarch";
    githubId = 6768842;
  };
  gvolpe = {
    name = "Gabriel Volpe";
    email = "volpegabriel@gmail.com";

    github = "gvolpe";
    githubId = 443978;
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
    name = "Harald Gliebe";
    email = "harald@glie.be";

    github = "hagl";
    githubId = 1162118;
  };
  hakuch = {
    name = "Jesse Haber-Kucharsky";
    email = "hakuch@gmail.com";

    github = "hakuch";
    githubId = 1498782;
  };
  hamburger1984 = {
    name = "Andreas Krohn";
    email = "hamburger1984@gmail.com";

    github = "hamburger1984";
    githubId = 438976;
  };
  hamhut1066 = {
    name = "Hamish Hutchings";
    email = "github@hamhut1066.com";

    github = "moredhel";
    githubId = 1742172;
  };
  hanemile = {
    name = "Emile Hansmaennel";
    email = "mail@emile.space";

    github = "HanEmile";
    githubId = 22756350;
  };
  hansjoergschurr = {
    name = "Hans-Jörg Schurr";
    email = "commits@schurr.at";

    github = "hansjoergschurr";
    githubId = 9850776;
  };
  HaoZeke = {
    name = "Rohit Goswami";
    email = "r95g10@gmail.com";

    github = "HaoZeke";
    githubId = 4336207;
    keys = [{
      fingerprint = "74B1 F67D 8E43 A94A 7554  0768 9CCC E364 02CB 49A6";
    }];
  };
  happy-river = {
    name = "Happy River";
    email = "happyriver93@runbox.com";

    github = "happy-river";
    githubId = 54728477;
  };
  happyalu = {
    name = "Alok Parlikar";
    email = "alok@parlikar.com";

    github = "happyalu";
    githubId = 231523;
  };
  happysalada = {
    name = "Raphael Megzari";
    email = "raphael@megzari.com";

    matrix = "@happysalada:matrix.org";
    github = "happysalada";
    githubId = 5317234;
  };
  hardselius = {
    name = "Martin Hardselius";
    email = "martin@hardselius.dev";

    github = "hardselius";
    githubId = 1422583;
    keys = [{
      fingerprint = "3F35 E4CA CBF4 2DE1 2E90  53E5 03A6 E6F7 8693 6619";
    }];
  };
  harrisonthorne = {
    name = "Harrison Thorne";
    email = "harrisonthorne@proton.me";

    github = "harrisonthorne";
    githubId = 33523827;
  };
  harvidsen = {
    name = "Håkon Arvidsen";
    email = "harvidsen@gmail.com";

    github = "harvidsen";
    githubId = 62279738;
  };
  haslersn = {
    name = "Sebastian Hasler";
    email = "haslersn@fius.informatik.uni-stuttgart.de";

    github = "haslersn";
    githubId = 33969028;
  };
  havvy = {
    name = "Ryan Scheel";
    email = "ryan.havvy@gmail.com";

    github = "Havvy";
    githubId = 731722;
  };
  hawkw = {
    name = "Eliza Weisman";
    email = "eliza@elizas.website";

    github = "hawkw";
    githubId = 2796466;
  };
  hax404 = {
    name = "Georg Haas";
    email = "hax404foogit@hax404.de";

    matrix = "@hax404:hax404.de";
    github = "hax404";
    githubId = 1379411;
  };
  hbunke = {
    name = "Hendrik Bunke";
    email = "bunke.hendrik@gmail.com";

    github = "hbunke";
    githubId = 1768793;
  };
  hce = {
    name = "Hans-Christian Esperer";
    email = "hc@hcesperer.org";

    github = "hce";
    githubId = 147689;
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
    name = "Hector Jusforgues";
    email = "hector.jusforgues+nixos@gmail.com";

    github = "hectorj";
    githubId = 2427959;
  };
  hedning = {
    name = "Tor Hedin Brønner";
    email = "torhedinbronner@gmail.com";

    github = "hedning";
    githubId = 71978;
  };
  heel = {
    name = "Sergii Paryzhskyi";
    email = "parizhskiy@gmail.com";

    github = "HeeL";
    githubId = 287769;
  };
  helium = {
    name = "helium";
    email = "helium.dev@tuta.io";

    github = "helium18";
    githubId = 86223025;
  };
  helkafen = {
    name = "Sébastian Méric de Bellefon";
    email = "arnaudpourseb@gmail.com";

    github = "Helkafen";
    githubId = 2405974;
  };
  henkery = {
    name = "Jim van Abkoude";
    email = "jim@reupload.nl";

    github = "henkery";
    githubId = 1923309;
  };
  henkkalkwater = {
    name = "Chris Josten";
    email = "chris+nixpkgs@netsoj.nl";

    matrix = "@chris:netsoj.nl";
    github = "HenkKalkwater";
    githubId = 4262067;
  };
  henrikolsson = {
    name = "Henrik Olsson";
    email = "henrik@fixme.se";

    github = "henrikolsson";
    githubId = 982322;
  };
  henrytill = {
    name = "Henry Till";
    email = "henrytill@gmail.com";

    github = "henrytill";
    githubId = 6430643;
  };
  heph2 = {
    name = "Marco";
    email = "srht@mrkeebs.eu";

    github = "heph2";
    githubId = 87579883;
  };
  herberteuler = {
    name = "Guanpeng Xu";
    email = "herberteuler@gmail.com";

    github = "herberteuler";
    githubId = 1401179;
  };
  hexa = {
    name = "Martin Weinelt";
    email = "hexa@darmstadt.ccc.de";

    matrix = "@hexa:lossy.network";
    github = "mweinelt";
    githubId = 131599;
  };
  hexagonal-sun = {
    name = "Matthew Leach";
    email = "dev@mattleach.net";

    github = "hexagonal-sun";
    githubId = 222664;
  };
  hexchen = {
    name = "hexchen";
    email = "nix@lilwit.ch";

    github = "hexchen";
    githubId = 41522204;
  };
  hh = {
    name = "Harry Ho";
    email = "hh@m-labs.hk";

    github = "HarryMakes";
    githubId = 66358631;
  };
  hhm = {
    name = "hhm";
    email = "heehooman+nixpkgs@gmail.com";

    github = "hhm0";
    githubId = 3656888;
  };
  hhydraa = {
    name = "hhydraa";
    email = "hcurfman@keemail.me";

    github = "hhydraa";
    githubId = 58676303;
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
    name = "Hiren Shah";
    email = "hiren@hiren.io";

    github = "hirenashah";
    githubId = 19825977;
  };
  hiro98 = {
    name = "Valentin Boettcher";
    email = "hiro@protagon.space";

    github = "vale981";
    githubId = 4025991;
    keys = [{
      fingerprint = "45A9 9917 578C D629 9F5F  B5B4 C22D 4DE4 D7B3 2D19";
    }];
  };
  hjones2199 = {
    name = "Hunter Jones";
    email = "hjones2199@gmail.com";

    github = "hjones2199";
    githubId = 5525217;
  };
  hkjn = {
    name = "Henrik Jonsson";
    email = "me@hkjn.me";

    github = "hkjn";
    githubId = 287215;
    keys = [{
      fingerprint = "D618 7A03 A40A 3D56 62F5  4B46 03EF BF83 9A5F DC15";
    }];
  };
  hleboulanger = {
    name = "Harold Leboulanger";
    email = "hleboulanger@protonmail.com";

    github = "thbkrshw";
    githubId = 33122;
  };
  hloeffler = {
    name = "Hauke Löffler";
    email = "nix@hauke-loeffler.de";

    github = "hloeffler";
    githubId = 6627191;
  };
  hlolli = {
    name = "Hlodver Sigurdsson";
    email = "hlolli@gmail.com";

    github = "hlolli";
    githubId = 6074754;
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
  hodapp = {
    name = "Chris Hodapp";
    email = "hodapp87@gmail.com";

    github = "Hodapp87";
    githubId = 896431;
  };
  holgerpeters = {
    name = "Holger Peters";
    email = "holger.peters@posteo.de";

    github = "HolgerPeters";
    githubId = 4097049;
  };
  hollowman6 = {
    name = "Songlin Jiang";
    email = "hollowman@hollowman.ml";

    github = "HollowMan6";
    githubId = 43995067;
  };
  holymonson = {
    name = "Monson Shao";
    email = "holymonson@gmail.com";

    github = "holymonson";
    githubId = 902012;
  };
  hongchangwu = {
    name = "Hongchang Wu";
    email = "wuhc85@gmail.com";

    github = "hongchangwu";
    githubId = 362833;
  };
  hoppla20 = {
    name = "Vincent Cui";
    email = "privat@vincentcui.de";

    github = "hoppla20";
    githubId = 25618740;
  };
  houstdav000 = {
    name = "David Houston";
    email = "houstdav000@gmail.com";

    matrix = "@houstdav000:gh0st.ems.host";
    github = "houstdav000";
    githubId = 17628961;
  };
  hoverbear = {
    name = "Ana Hobden";
    email = "operator+nix@hoverbear.org";

    matrix = "@hoverbear:matrix.org";
    github = "Hoverbear";
    githubId = 130903;
  };
  hqurve = {
    name = "hqurve";
    email = "hqurve@outlook.com";

    github = "hqurve";
    githubId = 53281855;
  };
  hrdinka = {
    name = "Christoph Hrdinka";
    email = "c.nix@hrdinka.at";

    github = "hrdinka";
    githubId = 1436960;
  };
  hrhino = {
    name = "Harrison Houghton";
    email = "hora.rhino@gmail.com";

    github = "hrhino";
    githubId = 28076058;
  };
  hschaeidt = {
    name = "Hendrik Schaeidt";
    email = "he.schaeidt@gmail.com";

    github = "hschaeidt";
    githubId = 1614615;
  };
  htr = {
    name = "Hugo Tavares Reis";
    email = "hugo@linux.com";

    github = "htr";
    githubId = 39689;
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
  hufman = {
    name = "Walter Huf";
    email = "hufman@gmail.com";

    github = "hufman";
    githubId = 1592375;
  };
  hugolgst = {
    name = "Hugo Lageneste";
    email = "hugo.lageneste@pm.me";

    github = "hugolgst";
    githubId = 15371828;
  };
  hugoreeves = {
    name = "Hugo Reeves";
    email = "hugo@hugoreeves.com";

    github = "HugoReeves";
    githubId = 20039091;
    keys = [{
      fingerprint = "78C2 E81C 828A 420B 269A  EBC1 49FA 39F8 A7F7 35F9";
    }];
  };
  humancalico = {
    name = "Akshat Agarwal";
    email = "humancalico@disroot.org";

    github = "humancalico";
    githubId = 51334444;
  };
  huyngo = {
    name = "Ngô Ngọc Đức Huy";
    email = "huyngo@disroot.org";

    github = "Huy-Ngo";
    githubId = 19296926;
    keys = [{
      fingerprint = "DF12 23B1 A9FD C5BE 3DA5  B6F7 904A F1C7 CDF6 95C3";
    }];
  };
  hypersw = {
    name = "Serge Baltic";
    email = "baltic@hypersw.net";

    github = "hypersw";
    githubId = 2332070;
  };
  hyphon81 = {
    name = "Masato Yonekawa";
    email = "zero812n@gmail.com";

    github = "hyphon81";
    githubId = 12491746;
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
    name = "Joris Masson";
    email = "hyzual@gmail.com";

    github = "Hyzual";
    githubId = 2051507;
  };
  hzeller = {
    name = "Henner Zeller";
    email = "h.zeller@acm.org";

    github = "hzeller";
    githubId = 140937;
  };
  i077 = {
    name = "Imran Hossain";
    email = "nixpkgs@imranhossa.in";

    github = "i077";
    githubId = 2789926;
  };
  iagoq = {
    name = "Iago Manoel Brito";
    email = "18238046+iagocq@users.noreply.github.com";

    github = "iagocq";
    githubId = 18238046;
    keys = [{
      fingerprint = "DF90 9D58 BEE4 E73A 1B8C  5AF3 35D3 9F9A 9A1B C8DA";
    }];
  };
  iammrinal0 = {
    name = "Mrinal";
    email = "nixpkgs@mrinalpurohit.in";

    matrix = "@iammrinal0:nixos.dev";
    github = "iAmMrinal0";
    githubId = 890062;
  };
  iand675 = {
    name = "Ian Duncan";
    email = "ian@iankduncan.com";

    github = "iand675";
    githubId = 69209;
  };
  ianmjones = {
    name = "Ian M. Jones";
    email = "ian@ianmjones.com";

    github = "ianmjones";
    githubId = 4710;
  };
  ianwookim = {
    name = "Ian-Woo Kim";
    email = "ianwookim@gmail.com";

    github = "wavewave";
    githubId = 1031119;
  };
  ibizaman = {
    name = "Pierre Penninckx";
    email = "ibizapeanut@gmail.com";

    github = "ibizaman";
    githubId = 1044950;
    keys = [{
      fingerprint = "A01F 10C6 7176 B2AE 2A34  1A56 D4C5 C37E 6031 A3FE";
    }];
  };
  iblech = {
    name = "Ingo Blechschmidt";
    email = "iblech@speicherleck.de";

    github = "iblech";
    githubId = 3661115;
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
    name = "Dominic Steinitz";
    email = "dominic@steinitz.org";

    github = "idontgetoutmuch";
    githubId = 1550265;
  };
  ifurther = {
    name = "Feather Lin";
    email = "55025025+ifurther@users.noreply.github.com";

    github = "ifurther";
    githubId = 55025025;
  };
  igsha = {
    name = "Igor Sharonov";
    email = "igor.sharonov@gmail.com";

    github = "igsha";
    githubId = 5345170;
  };
  iimog = {
    name = "Markus J. Ankenbrand";
    email = "iimog@iimog.org";

    github = "iimog";
    githubId = 7403236;
  };
  ikervagyok = {
    name = "Balázs Lengyel";
    email = "ikervagyok@gmail.com";

    github = "ikervagyok";
    githubId = 7481521;
  };
  ilian = {
    name = "Ilian";
    email = "ilian@tuta.io";

    github = "ilian";
    githubId = 25505957;
  };
  ilikeavocadoes = {
    name = "Lassi Haasio";
    email = "ilikeavocadoes@hush.com";

    github = "ilikeavocadoes";
    githubId = 36193715;
  };
  ilkecan = {
    name = "ilkecan bozdogan";
    email = "ilkecan@protonmail.com";

    matrix = "@ilkecan:matrix.org";
    github = "ilkecan";
    githubId = 40234257;
  };
  illegalprime = {
    name = "Michael Eden";
    email = "themichaeleden@gmail.com";

    github = "illegalprime";
    githubId = 4401220;
  };
  illiusdope = {
    name = "Mat Marini";
    email = "mat@marini.ca";

    github = "illiusdope";
    githubId = 61913481;
  };
  illustris = {
    name = "Harikrishnan R";
    email = "me@illustris.tech";

    github = "illustris";
    githubId = 3948275;
  };
  ilya-fedin = {
    name = "Ilya Fedin";
    email = "fedin-ilja2010@ya.ru";

    github = "ilya-fedin";
    githubId = 17829319;
  };
  ilya-kolpakov = {
    name = "Ilya Kolpakov";
    email = "ilya.kolpakov@gmail.com";

    github = "ilya-kolpakov";
    githubId = 592849;
  };
  ilyakooo0 = {
    name = "Ilya Kostyuchenko";
    email = "ilyakooo0@gmail.com";

    github = "ilyakooo0";
    githubId = 6209627;
  };
  imalison = {
    name = "Ivan Malison";
    email = "IvanMalison@gmail.com";

    github = "IvanMalison";
    githubId = 1246619;
  };
  imalsogreg = {
    name = "Greg Hale";
    email = "imalsogreg@gmail.com";

    github = "imalsogreg";
    githubId = 993484;
  };
  imgabe = {
    name = "Gabriel Pereira";
    email = "gabrielpmonte@hotmail.com";

    github = "ImGabe";
    githubId = 24387926;
  };
  imincik = {
    name = "Ivan Mincik";
    email = "ivan.mincik@gmail.com";

    matrix = "@imincik:matrix.org";
    github = "imincik";
    githubId = 476346;
  };
  imlonghao = {
    name = "Hao Long";
    email = "nixos@esd.cc";

    github = "imlonghao";
    githubId = 4951333;
  };
  immae = {
    name = "Ismaël Bouya";
    email = "ismael@bouya.org";

    matrix = "@immae:immae.eu";
    github = "immae";
    githubId = 510202;
  };
  impl = {
    name = "Noah Fontes";
    email = "noah@noahfontes.com";

    matrix = "@impl:matrix.org";
    github = "impl";
    githubId = 41129;
    keys = [{
      fingerprint = "F5B2 BE1B 9AAD 98FE 2916  5597 3665 FFF7 9D38 7BAA";
    }];
  };
  imsofi = {
    name = "Sofi";
    email = "sofi+git@mailbox.org";

    github = "imsofi";
    githubId = 20756843;
  };
  imuli = {
    name = "Imuli";
    email = "i@imu.li";

    github = "imuli";
    githubId = 4085046;
  };
  indeednotjames = {
    name = "Emily Lange";
    email = "nix@indeednotjames.com";

    github = "IndeedNotJames";
    githubId = 55066419;
  };
  ineol = {
    name = "Léo Stefanesco";
    email = "leo.stefanesco@gmail.com";

    github = "ineol";
    githubId = 37965;
  };
  infinidoge = {
    name = "Infinidoge";
    email = "infinidoge@inx.moe";

    github = "Infinidoge";
    githubId = 22727114;
  };
  infinisil = {
    name = "Silvan Mosberger";
    email = "contact@infinisil.com";

    matrix = "@infinisil:matrix.org";
    github = "infinisil";
    githubId = 20525370;
    keys = [{
      fingerprint = "6C2B 55D4 4E04 8266 6B7D  DA1A 422E 9EDA E015 7170";
    }];
  };
  ingenieroariel = {
    name = "Ariel Nunez";
    email = "ariel@nunez.co";

    github = "ingenieroariel";
    githubId = 54999;
  };
  iopq = {
    name = "Igor Polyakov";
    email = "iop_jr@yahoo.com";

    github = "iopq";
    githubId = 1817528;
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
    name = "Michele Catalano";
    email = "michele@catalano.de";

    github = "ironpinguin";
    githubId = 137306;
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
    name = "Joerie de Gram";
    email = "j.de.gram@gmail.com";

    matrix = "@ius:nltrix.net";
    github = "ius";
    githubId = 529626;
  };
  ivan = {
    name = "Ivan Kozik";
    email = "ivan@ludios.org";

    github = "ivan";
    githubId = 4458;
  };
  ivan-babrou = {
    name = "Ivan Babrou";
    email = "nixpkgs@ivan.computer";

    github = "bobrik";
    githubId = 89186;
  };
  ivan-timokhin = {
    name = "Ivan Timokhin";
    email = "nixpkgs@ivan.timokhin.name";

    github = "ivan-timokhin";
    githubId = 9802104;
  };
  ivan-tkatchev = {
    name = "Ivan Tkatchev";
    email = "tkatchev@gmail.com";

    github = "ivan-tkatchev";
    githubId = 650601;
  };
  ivanbrennan = {
    name = "Ivan Brennan";
    email = "ivan.brennan@gmail.com";

    github = "ivanbrennan";
    githubId = 1672874;
    keys = [{
      fingerprint = "7311 2700 AB4F 4CDF C68C  F6A5 79C3 C47D C652 EA54";
    }];
  };
  ivankovnatsky = {
    name = "Ivan Kovnatsky";
    email = "75213+ivankovnatsky@users.noreply.github.com";

    github = "ivankovnatsky";
    githubId = 75213;
    keys = [{
      fingerprint = "6BD3 7248 30BD 941E 9180  C1A3 3A33 FA4C 82ED 674F";
    }];
  };
  ivar = {
    name = "Ivar";
    email = "ivar.scholten@protonmail.com";

    github = "IvarWithoutBones";
    githubId = 41924494;
  };
  iwanb = {
    name = "Iwan";
    email = "tracnar@gmail.com";

    github = "iwanb";
    githubId = 4035835;
  };
  ixmatus = {
    name = "Parnell Springmeyer";
    email = "parnell@digitalmentat.com";

    github = "ixmatus";
    githubId = 30714;
  };
  ixxie = {
    name = "Matan Bendix Shenhav";
    email = "matan@fluxcraft.net";

    github = "ixxie";
    githubId = 20320695;
  };
  izorkin = {
    name = "Yurii Izorkin";
    email = "Izorkin@gmail.com";

    github = "Izorkin";
    githubId = 26877687;
  };
  j-brn = {
    name = "Jonas Braun";
    email = "me@bricker.io";

    github = "j-brn";
    githubId = 40566146;
  };
  j-hui = {
    name = "John Hui";
    email = "j-hui@cs.columbia.edu";

    github = "j-hui";
    githubId = 11800204;
  };
  j-keck = {
    name = "Jürgen Keck";
    email = "jhyphenkeck@gmail.com";

    github = "j-keck";
    githubId = 3081095;
  };
  j03 = {
    name = "Johannes Lötzsch";
    email = "github@johannesloetzsch.de";

    github = "johannesloetzsch";
    githubId = 175537;
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
  j0xaf = {
    name = "Jörn Gersdorf";
    email = "j0xaf@j0xaf.de";

    github = "j0xaf";
    githubId = 932697;
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
  jackgerrits = {
    name = "Jack Gerrits";
    email = "jack@jackgerrits.com";

    github = "jackgerrits";
    githubId = 7558482;
  };
  jagajaga = {
    name = "Arseniy Seroka";
    email = "ars.seroka@gmail.com";

    github = "jagajaga";
    githubId = 2179419;
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
  jakeisnt = {
    name = "Jacob Chvatal";
    email = "jake@isnt.online";

    github = "jakeisnt";
    githubId = 29869612;
  };
  jakelogemann = {
    name = "Jake Logemann";
    email = "jake.logemann@gmail.com";

    github = "jakelogemann";
    githubId = 820715;
  };
  jakestanger = {
    name = "Jake Stanger";
    email = "mail@jstanger.dev";

    github = "JakeStanger";
    githubId = 5057870;
  };
  jakewaksbaum = {
    name = "Jake Waksbaum";
    email = "jake.waksbaum@gmail.com";

    github = "jbaum98";
    githubId = 5283991;
  };
  jakubgs = {
    name = "Jakub Grzgorz Sokołowski";
    email = "jakub@gsokolowski.pl";

    github = "jakubgs";
    githubId = 2212681;
  };
  jali-clarke = {
    name = "Jinnah Ali-Clarke";
    email = "jinnah.ali-clarke@outlook.com";

    github = "jali-clarke";
    githubId = 17733984;
  };
  jamiemagee = {
    name = "Jamie Magee";
    email = "jamie.magee@gmail.com";

    github = "JamieMagee";
    githubId = 1358764;
  };
  jammerful = {
    name = "jammerful";
    email = "jammerful@gmail.com";

    github = "jammerful";
    githubId = 20176306;
  };
  jansol = {
    name = "Jan Solanti";
    email = "jan.solanti@paivola.fi";

    github = "jansol";
    githubId = 2588851;
  };
  jappie = {
    name = "Jappie Klooster";
    email = "jappieklooster@hotmail.com";

    github = "jappeace";
    githubId = 3874017;
  };
  jasoncarr = {
    name = "Jason Carr";
    email = "jcarr250@gmail.com";

    github = "jasoncarr0";
    githubId = 6874204;
  };
  javaguirre = {
    name = "Javier Aguirre";
    email = "contacto@javaguirre.net";

    github = "javaguirre";
    githubId = 488556;
  };
  jayesh-bhoot = {
    name = "Jayesh Bhoot";
    email = "jayesh@bhoot.sh";

    github = "jayeshbhoot";
    githubId = 1915507;
  };
  jb55 = {
    name = "William Casarin";
    email = "jb55@jb55.com";

    github = "jb55";
    githubId = 45598;
  };
  jbcrail = {
    name = "Joseph Crail";
    email = "jbcrail@gmail.com";

    github = "jbcrail";
    githubId = 6038;
  };
  jbedo = {
    name = "Justin Bedő";
    email = "cu@cua0.org";

    matrix = "@jb:vk3.wtf";
    github = "jbedo";
    githubId = 372912;
  };
  jbgi = {
    name = "Jean-Baptiste Giraudeau";
    email = "jb@giraudeau.info";

    github = "jbgi";
    githubId = 221929;
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
    name = "John Chadwick";
    email = "johnwchadwick@gmail.com";

    github = "jchv";
    githubId = 938744;
  };
  jcouyang = {
    name = "Jichao Ouyang";
    email = "oyanglulu@gmail.com";

    github = "jcouyang";
    githubId = 1235045;
    keys = [{
      fingerprint = "A506 C38D 5CC8 47D0 DF01  134A DA8B 833B 5260 4E63";
    }];
  };
  jcs090218 = {
    name = "Jen-Chieh Shen";
    email = "jcs090218@gmail.com";

    github = "jcs090218";
    githubId = 8685505;
  };
  jcumming = {
    name = "Jack Cummings";
    email = "jack@mudshark.org";

    github = "jcumming";
    githubId = 1982341;
  };
  jdagilliland = {
    name = "Jason Gilliland";
    email = "jdagilliland@gmail.com";

    github = "jdagilliland";
    githubId = 1383440;
  };
  jdahm = {
    name = "Johann Dahm";
    email = "johann.dahm@gmail.com";

    github = "jdahm";
    githubId = 68032;
  };
  jdanek = {
    name = "Jiri Daněk";
    email = "jdanek@redhat.com";

    github = "jirkadanek";
    githubId = 17877663;
    keys = [{
      fingerprint = "D4A6 F051 AD58 2E7C BCED  5439 6927 5CAD F15D 872E";
    }];
  };
  jdbaldry = {
    name = "Jack Baldry";
    email = "jack.baldry@grafana.com";

    github = "jdbaldry";
    githubId = 4599384;
  };
  jdehaas = {
    name = "Jeroen de Haas";
    email = "qqlq@nullptr.club";

    github = "jeroendehaas";
    githubId = 117874;
  };
  jdelStrother = {
    name = "Jonathan del Strother";
    email = "me@delstrother.com";

    github = "jdelStrother";
    githubId = 2377;
  };
  jdreaver = {
    name = "David Reaver";
    email = "johndreaver@gmail.com";

    github = "jdreaver";
    githubId = 1253071;
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
    name = "Jean-Charles Quillet";
    email = "jeancharles.quillet@gmail.com";

    github = "jecaro";
    githubId = 17029738;
  };
  jefdaj = {
    name = "Jeffrey David Johnson";
    email = "jefdaj@gmail.com";

    github = "jefdaj";
    githubId = 1198065;
  };
  jefflabonte = {
    name = "Jean-François Labonté";
    email = "grimsleepless@protonmail.com";

    github = "JeffLabonte";
    githubId = 9425955;
  };
  jensbin = {
    name = "Jens Binkert";
    email = "jensbin+git@pm.me";

    github = "jensbin";
    githubId = 1608697;
  };
  jeremyschlatter = {
    name = "Jeremy Schlatter";
    email = "github@jeremyschlatter.com";

    github = "jeremyschlatter";
    githubId = 5741620;
  };
  jerith666 = {
    name = "Matt McHenry";
    email = "github@matt.mchenryfamily.org";

    github = "jerith666";
    githubId = 854319;
  };
  jeschli = {
    name = "Markus Hihn";
    email = "jeschli@gmail.com";

    github = "0mbi";
    githubId = 10786794;
  };
  jethro = {
    name = "Jethro Kuan";
    email = "jethrokuan95@gmail.com";

    github = "jethrokuan";
    githubId = 1667473;
  };
  jevy = {
    name = "Jevin Maltais";
    email = "jevin@quickjack.ca";

    github = "jevy";
    githubId = 110620;
  };
  jfb = {
    name = "James Felix Black";
    email = "james@yamtime.com";

    github = "tftio";
    githubId = 143075;
  };
  jfchevrette = {
    name = "Jean-Francois Chevrette";
    email = "jfchevrette@gmail.com";

    github = "jfchevrette";
    githubId = 3001;
    keys = [{
      fingerprint = "B612 96A9 498E EECD D5E9  C0F0 67A0 5858 0129 0DC6";
    }];
  };
  jflanglois = {
    name = "Julien Langlois";
    email = "yourstruly@julienlanglois.me";

    github = "jflanglois";
    githubId = 18501;
  };
  jfrankenau = {
    name = "Johannes Frankenau";
    email = "johannes@frankenau.net";

    github = "jfrankenau";
    githubId = 2736480;
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
    name = "Jorge Gomez";
    email = "jgart@dismail.de";

    github = "jgarte";
    githubId = 47760695;
  };
  jgeerds = {
    name = "Jascha Geerds";
    email = "jascha@geerds.org";

    github = "jgeerds";
    githubId = 1473909;
  };
  jgertm = {
    name = "Tim Jaeger";
    email = "jger.tm@gmail.com";

    github = "jgertm";
    githubId = 6616642;
  };
  jgillich = {
    name = "Jakob Gillich";
    email = "jakob@gillich.me";

    github = "jgillich";
    githubId = 347965;
  };
  jglukasik = {
    name = "Joseph Lukasik";
    email = "joseph@jgl.me";

    github = "jglukasik";
    githubId = 6445082;
  };
  jhh = {
    name = "Jeff Hutchison";
    email = "jeff@j3ff.io";

    github = "jhh";
    githubId = 14412;
  };
  jhhuh = {
    name = "Ji-Haeng Huh";
    email = "jhhuh.note@gmail.com";

    github = "jhhuh";
    githubId = 5843245;
  };
  jhillyerd = {
    name = "James Hillyerd";
    email = "james+nixos@hillyerd.com";

    github = "jhillyerd";
    githubId = 2502736;
  };
  jiegec = {
    name = "Jiajie Chen";
    email = "c@jia.je";

    github = "jiegec";
    githubId = 6127678;
  };
  jiehong = {
    name = "Jiehong Ma";
    email = "nixos@majiehong.com";

    github = "Jiehong";
    githubId = 1061229;
  };
  jirkamarsik = {
    name = "Jirka Marsik";
    email = "jiri.marsik89@gmail.com";

    github = "jirkamarsik";
    githubId = 184898;
  };
  jitwit = {
    name = "jitwit";
    email = "jrn@bluefarm.ca";

    github = "jitwit";
    githubId = 51518420;
  };
  jjjollyjim = {
    name = "Jamie McClymont";
    email = "jamie@kwiius.com";

    github = "JJJollyjim";
    githubId = 691552;
  };
  jk = {
    name = "Jack";
    email = "hello+nixpkgs@j-k.io";

    matrix = "@j-k:matrix.org";
    github = "06kellyjac";
    githubId = 9866621;
  };
  jkarlson = {
    name = "Emil Karlson";
    email = "jekarlson@gmail.com";

    github = "jkarlson";
    githubId = 1204734;
  };
  jlamur = {
    name = "Jules Lamur";
    email = "contact@juleslamur.fr";

    github = "jlamur";
    githubId = 7054317;
    keys = [{
      fingerprint = "B768 6CD7 451A 650D 9C54  4204 6710 CF0C 1CBD 7762";
    }];
  };
  jlesquembre = {
    name = "José Luis Lafuente";
    email = "jl@lafuente.me";

    github = "jlesquembre";
    githubId = 1058504;
  };
  jloyet = {
    name = "Jérôme Loyet";
    email = "ml@fatbsd.com";

    github = "fatpat";
    githubId = 822436;
  };
  jluttine = {
    name = "Jaakko Luttinen";
    email = "jaakko.luttinen@iki.fi";

    github = "jluttine";
    githubId = 2195834;
  };
  jm2dev = {
    name = "José Miguel Martínez Carrasco";
    email = "jomarcar@gmail.com";

    github = "jm2dev";
    githubId = 474643;
  };
  jmagnusj = {
    name = "Johan Magnus Jonsson";
    email = "jmagnusj@gmail.com";

    github = "magnusjonsson";
    githubId = 8900;
  };
  jmc-figueira = {
    name = "João Figueira";
    email = "business+nixos@jmc-figueira.dev";

    github = "jmc-figueira";
    githubId = 6634716;
    keys = [
      {
        fingerprint = "EC08 7AA3 DEAD A972 F015  6371 DC7A E56A E98E 02D7";
      }

      {
        fingerprint = "816D 23F5 E672 EC58 7674  4A73 197F 9A63 2D13 9E30";
      }
    ];
  };
  jmettes = {
    name = "Jonathan Mettes";
    email = "jonathan@jmettes.com";

    github = "jmettes";
    githubId = 587870;
  };
  jmgilman = {
    name = "Joshua Gilman";
    email = "joshuagilman@gmail.com";

    github = "jmgilman";
    githubId = 2308444;
  };
  jo1gi = {
    name = "Joakim Holm";
    email = "joakimholm@protonmail.com";

    github = "jo1gi";
    githubId = 26695750;
  };
  joachifm = {
    name = "Joachim Fasting";
    email = "joachifm@fastmail.fm";

    github = "joachifm";
    githubId = 41977;
  };
  joachimschmidt557 = {
    name = "Joachim Schmidt";
    email = "joachim.schmidt557@outlook.com";

    github = "joachimschmidt557";
    githubId = 28556218;
  };
  joamaki = {
    name = "Jussi Maki";
    email = "joamaki@gmail.com";

    github = "joamaki";
    githubId = 1102396;
  };
  jobojeha = {
    name = "Jonathan Jeppener-Haltenhoff";
    email = "jobojeha@jeppener.de";

    github = "jobojeha";
    githubId = 60272884;
  };
  jocelynthode = {
    name = "Jocelyn Thode";
    email = "jocelyn.thode@gmail.com";

    github = "jocelynthode";
    githubId = 3967312;
  };
  joedevivo = {
    name = "Joe DeVivo";
    email = "55951+joedevivo@users.noreply.github.com";

    github = "joedevivo";
    githubId = 55951;
  };
  joelancaster = {
    name = "Joe Lancaster";
    email = "joe.a.lancas@gmail.com";

    github = "JoeLancaster";
    githubId = 16760945;
  };
  joelburget = {
    name = "Joel Burget";
    email = "joelburget@gmail.com";

    github = "joelburget";
    githubId = 310981;
  };
  joelmo = {
    name = "Joel Moberg";
    email = "joel.moberg@gmail.com";

    github = "joelmo";
    githubId = 336631;
  };
  joepie91 = {
    name = "Sven Slootweg";
    email = "admin@cryto.net";

    matrix = "@joepie91:pixie.town";
    github = "joepie91";
    githubId = 1663259;
  };
  joesalisbury = {
    name = "Joe Salisbury";
    email = "salisbury.joseph@gmail.com";

    github = "JosephSalisbury";
    githubId = 297653;
  };
  johanot = {
    name = "Johan Thomsen";
    email = "write@ownrisk.dk";

    github = "johanot";
    githubId = 998763;
  };
  johbo = {
    name = "Johannes Bornhold";
    email = "johannes@bornhold.name";

    github = "johbo";
    githubId = 117805;
  };
  john-shaffer = {
    name = "John Shaffer";
    email = "jdsha@proton.me";

    github = "john-shaffer";
    githubId = 53870456;
  };
  johnazoidberg = {
    name = "Daniel Schäfer";
    email = "git@danielschaefer.me";

    github = "JohnAZoidberg";
    githubId = 5307138;
  };
  johnchildren = {
    name = "John Children";
    email = "john.a.children@gmail.com";

    github = "johnchildren";
    githubId = 32305209;
  };
  johnmh = {
    name = "John M. Harris, Jr.";
    email = "johnmh@openblox.org";

    github = "JohnMH";
    githubId = 2576152;
  };
  johnramsden = {
    name = "John Ramsden";
    email = "johnramsden@riseup.net";

    github = "johnramsden";
    githubId = 8735102;
  };
  johnrichardrinehart = {
    name = "John Rinehart";
    email = "johnrichardrinehart@gmail.com";

    github = "johnrichardrinehart";
    githubId = 6321578;
  };
  johntitor = {
    name = "Yuki Okushi";
    email = "huyuumi.dev@gmail.com";

    github = "JohnTitor";
    githubId = 25030997;
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
    name = "Ioannis Koutras";
    email = "ioannis.koutras@gmail.com";

    github = "jokogr";
    githubId = 1252547;
    keys = [{
      fingerprint = "B154 A8F9 0610 DB45 0CA8  CF39 85EA E7D9 DF56 C5CA";
    }];
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
    name = "Jon Banafato";
    email = "jon@jonafato.com";

    github = "jonafato";
    githubId = 392720;
  };
  jonathanmarler = {
    name = "Jonathan Marler";
    email = "johnnymarler@gmail.com";

    github = "marler8997";
    githubId = 304904;
  };
  jonathanreeve = {
    name = "Jonathan Reeve";
    email = "jon.reeve@gmail.com";

    github = "JonathanReeve";
    githubId = 1843676;
  };
  jonnybolton = {
    name = "Jonny Bolton";
    email = "jonnybolton@gmail.com";

    github = "jonnybolton";
    githubId = 8580434;
  };
  jonringer = {
    name = "Jonathan Ringer";
    email = "jonringer117@gmail.com";

    matrix = "@jonringer:matrix.org";
    github = "jonringer";
    githubId = 7673602;
  };
  jordanisaacs = {
    name = "Jordan Isaacs";
    email = "nix@jdisaacs.com";

    github = "jordanisaacs";
    githubId = 19742638;
  };
  jorise = {
    name = "Joris Engbers";
    email = "info@jorisengbers.nl";

    github = "JorisE";
    githubId = 1767283;
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
    name = "Josh van Leeuwen";
    email = " me@joshvanl.dev ";

    github = "JoshVanL";
    githubId = 15893072;
  };
  jpagex = {
    name = "Jérémy Pagé";
    email = "contact@jeremypage.me";

    github = "jpagex";
    githubId = 635768;
  };
  jpas = {
    name = "Jarrod Pas";
    email = "jarrod@jarrodpas.com";

    github = "jpas";
    githubId = 5689724;
  };
  jpdoyle = {
    name = "Joe Doyle";
    email = "joethedoyle@gmail.com";

    github = "jpdoyle";
    githubId = 1918771;
  };
  jperras = {
    name = "Joël Perras";
    email = "joel@nerderati.com";

    github = "jperras";
    githubId = 20675;
  };
  jpetrucciani = {
    name = "Jacobi Petrucciani";
    email = "j@cobi.dev";

    github = "jpetrucciani";
    githubId = 8117202;
  };
  jpierre03 = {
    name = "Jean-Pierre PRUNARET";
    email = "nix@prunetwork.fr";

    github = "jpierre03";
    githubId = 954536;
  };
  jpotier = {
    name = "Martin Potier";
    email = "jpo.contributes.to.nixos@marvid.fr";

    github = "jpotier";
    githubId = 752510;
  };
  jqqqqqqqqqq = {
    name = "Curtis Jiang";
    email = "jqqqqqqqqqq@gmail.com";

    github = "jqqqqqqqqqq";
    githubId = 12872927;
  };
  jqueiroz = {
    name = "Jonathan Queiroz";
    email = "nixos@johnjq.com";

    github = "jqueiroz";
    githubId = 4968215;
  };
  jraygauthier = {
    name = "Raymond Gauthier";
    email = "jraygauthier@gmail.com";

    github = "jraygauthier";
    githubId = 4611077;
  };
  jrpotter = {
    name = "Joshua Potter";
    email = "jrpotter2112@gmail.com";

    github = "jrpotter";
    githubId = 3267697;
  };
  jshcmpbll = {
    name = "Joshua Campbell";
    email = "me@joshuadcampbell.com";

    github = "jshcmpbll";
    githubId = 16374374;
  };
  jshholland = {
    name = "Josh Holland";
    email = "josh@inv.alid.pw";

    github = "jshholland";
    githubId = 107689;
  };
  jsierles = {
    name = "Joshua Sierles";
    email = "joshua@hey.com";

    matrix = "@jsierles:matrix.org";
    github = "jsierles";
    githubId = 82;
  };
  jsimonetti = {
    name = "Jeroen Simonetti";
    email = "jeroen+nixpkgs@simonetti.nl";

    matrix = "@jeroen:simonetti.nl";
    github = "jsimonetti";
    githubId = 5478838;
  };
  jsoo1 = {
    name = "John Soo";
    email = "jsoo1@asu.edu";

    github = "jsoo1";
    githubId = 10039785;
  };
  jtcoolen = {
    name = "Julien Coolen";
    email = "jtcoolen@pm.me";

    github = "jtcoolen";
    githubId = 54635632;
    keys = [{
      fingerprint = "4C68 56EE DFDA 20FB 77E8  9169 1964 2151 C218 F6F5";
    }];
  };
  jtobin = {
    name = "Jared Tobin";
    email = "jared@jtobin.io";

    github = "jtobin";
    githubId = 1414434;
  };
  jtojnar = {
    name = "Jan Tojnar";
    email = "jtojnar@gmail.com";

    matrix = "@jtojnar:matrix.org";
    github = "jtojnar";
    githubId = 705123;
  };
  jtrees = {
    name = "Joshua Trees";
    email = "me@jtrees.io";

    github = "jtrees";
    githubId = 5802758;
  };
  juaningan = {
    name = "Juan Rodal";
    email = "juaningan@gmail.com";

    github = "uningan";
    githubId = 810075;
  };
  juboba = {
    name = "Julio Borja Barra";
    email = "juboba@gmail.com";

    github = "juboba";
    githubId = 1189739;
  };
  jugendhacker = {
    name = "j.r";
    email = "j.r@jugendhacker.de";

    matrix = "@j.r:chaos.jetzt";
    github = "jugendhacker";
    githubId = 12773748;
  };
  juliendehos = {
    name = "Julien Dehos";
    email = "dehos@lisic.univ-littoral.fr";

    github = "juliendehos";
    githubId = 11947756;
  };
  julienmalka = {
    name = "Julien Malka";
    email = "julien.malka@me.com";

    github = "JulienMalka";
    githubId = 1792886;
  };
  julm = {
    name = "Julien Moutinho";
    email = "julm+nixpkgs@sourcephile.fr";

    github = "ju1m";
    githubId = 21160136;
  };
  jumper149 = {
    name = "Felix Springer";
    email = "felixspringer149@gmail.com";

    github = "jumper149";
    githubId = 39434424;
  };
  junjihashimoto = {
    name = "Junji Hashimoto";
    email = "junji.hashimoto@gmail.com";

    github = "junjihashimoto";
    githubId = 2469618;
  };
  justinas = {
    name = "Justinas Stankevičius";
    email = "justinas@justinas.org";

    github = "justinas";
    githubId = 662666;
  };
  justinlovinger = {
    name = "Justin Lovinger";
    email = "git@justinlovinger.com";

    github = "JustinLovinger";
    githubId = 7183441;
  };
  justinwoo = {
    name = "Justin Woo";
    email = "moomoowoo@gmail.com";

    github = "justinwoo";
    githubId = 2396926;
  };
  jvanbruegge = {
    name = "Jan van Brügge";
    email = "supermanitu@gmail.com";

    github = "jvanbruegge";
    githubId = 1529052;
    keys = [{
      fingerprint = "3513 5CE5 77AD 711F 3825  9A99 3665 72BE 7D6C 78A2";
    }];
  };
  jwatt = {
    name = "Jesse Wattenbarger";
    email = "jwatt@broken.watch";

    github = "jjwatt";
    githubId = 2397327;
  };
  jwiegley = {
    name = "John Wiegley";
    email = "johnw@newartisans.com";

    github = "jwiegley";
    githubId = 8460;
  };
  jwijenbergh = {
    name = "Jeroen Wijenbergh";
    email = "jeroenwijenbergh@protonmail.com";

    github = "jwijenbergh";
    githubId = 46386452;
  };
  jwoudenberg = {
    name = "Jasper Woudenberg";
    email = "nixpkgs@jasperwoudenberg.com";

    github = "jwoudenberg";
    githubId = 1525551;
  };
  jwygoda = {
    name = "Jarosław Wygoda";
    email = "jaroslaw@wygoda.me";

    github = "jwygoda";
    githubId = 20658981;
  };
  jyooru = {
    name = "Joel";
    email = "joel@joel.tokyo";

    github = "jyooru";
    githubId = 63786778;
  };
  jyp = {
    name = "Jean-Philippe Bernardy";
    email = "jeanphilippe.bernardy@gmail.com";

    github = "jyp";
    githubId = 27747;
  };
  jzellner = {
    name = "Jeff Zellner";
    email = "jeffz@eml.cc";

    github = "sofuture";
    githubId = 66669;
  };
  k3a = {
    name = "Mario Hros";
    email = "git+nix@catmail.app";

    github = "k3a";
    githubId = 966992;
  };
  k900 = {
    name = "Ilya K.";
    email = "me@0upti.me";

    matrix = "@k900:0upti.me";
    github = "K900";
    githubId = 386765;
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
    name = "Kai Harries";
    email = "kai.harries@gmail.com";

    github = "KaiHa";
    githubId = 6544084;
  };
  kalbasit = {
    name = "Wael Nasreddine";
    email = "wael.nasreddine@gmail.com";

    matrix = "@kalbasit:matrix.org";
    github = "kalbasit";
    githubId = 87115;
  };
  kalekseev = {
    name = "Konstantin Alekseev";
    email = "mail@kalekseev.com";

    github = "kalekseev";
    githubId = 367259;
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
    name = "Kamil Chmielewski";
    email = "kamil.chm@gmail.com";

    github = "kamilchm";
    githubId = 1621930;
  };
  kampfschlaefer = {
    name = "Arnold Krille";
    email = "arnold@arnoldarts.de";

    github = "kampfschlaefer";
    githubId = 3831860;
  };
  kanashimia = {
    name = "Mia Kanashi";
    email = "chad@redpilled.dev";

    github = "kanashimia";
    githubId = 56224949;
  };
  karantan = {
    name = "Gasper Vozel";
    email = "karantan@gmail.com";

    github = "karantan";
    githubId = 7062631;
  };
  KarlJoad = {
    name = "Karl Hallsby";
    email = "karl@hallsby.com";

    github = "KarlJoad";
    githubId = 34152449;
  };
  karolchmist = {
    name = "karolchmist";
    email = "info+nix@chmist.com";

    github = "karolchmist";
    githubId = 1927188;
  };
  kayhide = {
    name = "Hideaki Kawai";
    email = "kayhide@gmail.com";

    github = "kayhide";
    githubId = 1730718;
  };
  kazcw = {
    name = "Kaz Wesley";
    email = "kaz@lambdaverse.org";

    github = "kazcw";
    githubId = 1047859;
  };
  kcalvinalvin = {
    name = "Calvin Kim";
    email = "calvin@kcalvinalvin.info";

    github = "kcalvinalvin";
    githubId = 37185887;
  };
  keksbg = {
    name = "Stella";
    email = "keksbg@riseup.net";

    github = "keksbg";
    githubId = 10682187;
    keys = [{
      fingerprint = "AB42 1F18 5A19 A160 AD77  9885 3D6D CA5B 6F2C 2A7A";
    }];
  };
  keldu = {
    name = "Claudius Holeksa";
    email = "mail@keldu.de";

    github = "keldu";
    githubId = 15373888;
  };
  ken-matsui = {
    name = "Ken Matsui";
    email = "nix@kmatsui.me";

    github = "ken-matsui";
    githubId = 26405363;
    keys = [{
      fingerprint = "3611 8CD3 6DE8 3334 B44A  DDE4 1033 60B3 298E E433";
    }];
  };
  kennyballou = {
    name = "Kenny Ballou";
    email = "kb@devnulllabs.io";

    github = "kennyballou";
    githubId = 2186188;
    keys = [{
      fingerprint = "932F 3E8E 1C0F 4A98 95D7  B8B8 B0CA A28A 0295 8308";
    }];
  };
  kenran = {
    name = "Johannes Maier";
    email = "johannes.maier@mailbox.org";

    matrix = "@kenran_:matrix.org";
    github = "kenranunderscore";
    githubId = 5188977;
  };
  kentjames = {
    name = "James Kent";
    email = "jameschristopherkent@gmail.com";

    github = "KentJames";
    githubId = 2029444;
  };
  kephasp = {
    name = "Pierre Thierry";
    email = "pierre@nothos.net";

    github = "kephas";
    githubId = 762421;
  };
  ketzacoatl = {
    name = "ketzacoatl";
    email = "ketzacoatl@protonmail.com";

    github = "ketzacoatl";
    githubId = 10122937;
  };
  kevincox = {
    name = "Kevin Cox";
    email = "kevincox@kevincox.ca";

    matrix = "@kevincox:matrix.org";
    github = "kevincox";
    githubId = 494012;
  };
  kevingriffin = {
    name = "Kevin Griffin";
    email = "me@kevin.jp";

    github = "kevingriffin";
    githubId = 209729;
  };
  kevink = {
    name = "Kevin Kandlbinder";
    email = "kevin@kevink.dev";

    github = "Unkn0wnCat";
    githubId = 8211181;
  };
  kfears = {
    name = "KFears";
    email = "kfearsoff@gmail.com";

    matrix = "@kfears:matrix.org";
    github = "KFearsoff";
    githubId = 66781795;
  };
  kfollesdal = {
    name = "Kristoffer K. Føllesdal";
    email = "kfollesdal@gmail.com";

    github = "kfollesdal";
    githubId = 546087;
  };
  kho-dialga = {
    name = "Iván Brito";
    email = "ivandashenyou@gmail.com";

    github = "Kho-Dialga";
    githubId = 55767703;
  };
  khumba = {
    name = "Bryan Gardiner";
    email = "bog@khumba.net";

    github = "khumba";
    githubId = 788813;
  };
  khushraj = {
    name = "Khushraj Rathod";
    email = "khushraj.rathod@gmail.com";

    github = "khrj";
    githubId = 44947946;
    keys = [{
      fingerprint = "1988 3FD8 EA2E B4EC 0A93  1E22 B77B 2A40 E770 2F19";
    }];
  };
  KibaFox = {
    name = "Kiba Fox";
    email = "kiba.fox@foxypossibilities.com";

    github = "KibaFox";
    githubId = 16481032;
  };
  kidd = {
    name = "Raimon Grau";
    email = "raimonster@gmail.com";

    github = "kidd";
    githubId = 25607;
  };
  kidonng = {
    name = "Kid";
    email = "hi@xuann.wang";

    github = "kidonng";
    githubId = 44045911;
  };
  kierdavis = {
    name = "Kier Davis";
    email = "kierdavis@gmail.com";

    github = "kierdavis";
    githubId = 845652;
  };
  kilimnik = {
    name = "Daniel Kilimnik";
    email = "mail@kilimnik.de";

    github = "kilimnik";
    githubId = 5883283;
  };
  killercup = {
    name = "Pascal Hertleif";
    email = "killercup@gmail.com";

    github = "killercup";
    githubId = 20063;
  };
  kiloreux = {
    name = "Kiloreux Emperex";
    email = "kiloreux@gmail.com";

    github = "kiloreux";
    githubId = 6282557;
  };
  kim0 = {
    name = "Ahmed Kamal";
    email = "email.ahmedkamal@googlemail.com";

    github = "kim0";
    githubId = 59667;
  };
  kimat = {
    name = "Kimat Boven";
    email = "mail@kimat.org";

    github = "kimat";
    githubId = 3081769;
  };
  kimburgess = {
    name = "Kim Burgess";
    email = "kim@acaprojects.com";

    github = "kimburgess";
    githubId = 843652;
  };
  kini = {
    name = "Keshav Kini";
    email = "keshav.kini@gmail.com";

    github = "kini";
    githubId = 691290;
  };
  kira-bruneau = {
    name = "Kira Bruneau";
    email = "kira.bruneau@pm.me";

    github = "kira-bruneau";
    githubId = 382041;
  };
  kirelagin = {
    name = "Kirill Elagin";
    email = "kirelagin@gmail.com";

    matrix = "@kirelagin:matrix.org";
    github = "kirelagin";
    githubId = 451835;
  };
  kirikaza = {
    name = "Kirill Kazakov";
    email = "k@kirikaza.ru";

    github = "kirikaza";
    githubId = 804677;
  };
  kisonecat = {
    name = "Jim Fowler";
    email = "kisonecat@gmail.com";

    github = "kisonecat";
    githubId = 148352;
  };
  kittywitch = {
    name = "Kat Inskip";
    email = "kat@inskip.me";

    github = "kittywitch";
    githubId = 67870215;
    keys = [{
      fingerprint = "9CC6 44B5 69CD A59B C874  C4C9 E8DD E3ED 1C90 F3A0";
    }];
  };
  kiwi = {
    name = "Robert Djubek";
    email = "envy1988@gmail.com";

    github = "Kiwi";
    githubId = 35715;
    keys = [{
      fingerprint = "8992 44FC D291 5CA2 0A97  802C 156C 88A5 B0A0 4B2A";
    }];
  };
  kjeremy = {
    name = "Jeremy Kolb";
    email = "kjeremy@gmail.com";

    github = "kjeremy";
    githubId = 4325700;
  };
  kkharji = {
    name = "kkharji";
    email = "kkharji@protonmail.com";

    github = "kkharji";
    githubId = 65782666;
  };
  klden = {
    name = "Kenzyme Le";
    email = "kl@kenzymele.com";

    github = "klDen";
    githubId = 5478260;
  };
  klntsky = {
    name = "Vladimir Kalnitsky";
    email = "klntsky@gmail.com";

    github = "klntsky";
    githubId = 18447310;
  };
  kloenk = {
    name = "Finn Behrens";
    email = "me@kloenk.dev";

    matrix = "@kloenk:petabyte.dev";
    github = "Kloenk";
    githubId = 12898828;
    keys = [{
      fingerprint = "6881 5A95 D715 D429 659B  48A4 B924 45CF C954 6F9D";
    }];
  };
  kmcopper = {
    name = "Kyle Copperfield";
    email = "kmcopper@danwin1210.me";

    github = "kmcopper";
    githubId = 57132115;
  };
  kmeakin = {
    name = "Karl Meakin";
    email = "karlwfmeakin@gmail.com";

    github = "Kmeakin";
    githubId = 19665139;
  };
  kmein = {
    name = "Kierán Meinhardt";
    email = "kmein@posteo.de";

    github = "kmein";
    githubId = 10352507;
  };
  kmicklas = {
    name = "Ken Micklas";
    email = "maintainer@kmicklas.com";

    github = "kmicklas";
    githubId = 929096;
  };
  knairda = {
    name = "Adrian Kummerlaender";
    email = "adrian@kummerlaender.eu";

    github = "KnairdA";
    githubId = 498373;
  };
  knedlsepp = {
    name = "Josef Kemetmüller";
    email = "josef.kemetmueller@gmail.com";

    github = "knedlsepp";
    githubId = 3287933;
  };
  knl = {
    name = "Nikola Knežević";
    email = "nikola@knezevic.co";

    github = "knl";
    githubId = 361496;
  };
  kolaente = {
    name = "Konrad Langenberg";
    email = "k@knt.li";

    github = "kolaente";
    githubId = 13721712;
  };
  kolbycrouch = {
    name = "Kolby Crouch";
    email = "kjc.devel@gmail.com";

    github = "kolbycrouch";
    githubId = 6346418;
  };
  kolloch = {
    name = "Peter Kolloch";
    email = "info@eigenvalue.net";

    github = "kolloch";
    githubId = 339354;
  };
  konimex = {
    name = "Muhammad Herdiansyah";
    email = "herdiansyah@netc.eu";

    github = "konimex";
    githubId = 15692230;
  };
  koozz = {
    name = "Jan van den Berg";
    email = "koozz@linux.com";

    github = "koozz";
    githubId = 264372;
  };
  koral = {
    name = "Koral";
    email = "koral@mailoo.org";

    github = "k0ral";
    githubId = 524268;
  };
  koslambrou = {
    name = "Konstantinos";
    email = "koslambrou@gmail.com";

    github = "koslambrou";
    githubId = 2037002;
  };
  kototama = {
    name = "Kototama";
    email = "kototama@posteo.jp";

    github = "kototama";
    githubId = 128620;
  };
  kouyk = {
    name = "Steven Kou";
    email = "skykinetic@stevenkou.xyz";

    github = "kouyk";
    githubId = 1729497;
  };
  kovirobi = {
    name = "Kovacsics Robert";
    email = "kovirobi@gmail.com";

    github = "KoviRobi";
    githubId = 1903418;
  };
  kquick = {
    name = "Kevin Quick";
    email = "quick@sparq.org";

    github = "kquick";
    githubId = 787421;
  };
  kradalby = {
    name = "Kristoffer Dalby";
    email = "kristoffer@dalby.cc";

    github = "kradalby";
    githubId = 98431;
  };
  kraem = {
    name = "Ronnie Ebrin";
    email = "me@kraem.xyz";

    github = "kraem";
    githubId = 26622971;
  };
  kragniz = {
    name = "Louis Taylor";
    email = "louis@kragniz.eu";

    github = "kragniz";
    githubId = 735008;
  };
  kranzes = {
    name = "Ilan Joselevich";
    email = "personal@ilanjoselevich.com";

    github = "Kranzes";
    githubId = 56614642;
  };
  krav = {
    name = "Kristoffer Thømt Ravneberg";
    email = "kristoffer@microdisko.no";

    github = "krav";
    githubId = 4032;
  };
  kristian-brucaj = {
    name = "Kristian Brucaj";
    email = "kbrucaj@gmail.com";

    github = "Kristian-Brucaj";
    githubId = 8893110;
  };
  kristoff3r = {
    name = "Kristoffer Søholm";
    email = "k.soeholm@gmail.com";

    github = "kristoff3r";
    githubId = 160317;
  };
  kritnich = {
    name = "Kritnich";
    email = "kritnich@kritni.ch";

    github = "Kritnich";
    githubId = 22116767;
  };
  kroell = {
    name = "Matthias Axel Kröll";
    email = "nixosmainter@makroell.de";

    github = "rokk4";
    githubId = 17659803;
  };
  ktf = {
    name = "Giuluo Eulisse";
    email = "giulio.eulisse@cern.ch";

    github = "ktf";
    githubId = 10544;
  };
  kthielen = {
    name = "Kalani Thielen";
    email = "kthielen@gmail.com";

    github = "kthielen";
    githubId = 1409287;
  };
  ktor = {
    name = "Pawel Kruszewski";
    email = "kruszewsky@gmail.com";

    github = "ktor";
    githubId = 99639;
  };
  kubukoz = {
    name = "Jakub Kozłowski";
    email = "kubukoz@gmail.com";

    github = "kubukoz";
    githubId = 894884;
  };
  kurnevsky = {
    name = "Evgeny Kurnevsky";
    email = "kurnevsky@gmail.com";

    github = "kurnevsky";
    githubId = 2943605;
  };
  kuwii = {
    name = "kuwii";
    email = "kuwii.someone@gmail.com";

    github = "kuwii";
    githubId = 10705175;
  };
  kuznero = {
    name = "Roman Kuznetsov";
    email = "roman@kuznero.com";

    github = "kuznero";
    githubId = 449813;
  };
  kwohlfahrt = {
    name = "Kai Wohlfahrt";
    email = "kai.wohlfahrt@gmail.com";

    github = "kwohlfahrt";
    githubId = 2422454;
  };
  kyleondy = {
    name = "Kyle Ondy";
    email = "kyle@ondy.org";

    github = "KyleOndy";
    githubId = 1640900;
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
    name = "Las Safin";
    email = "las@protonmail.ch";

    matrix = "@Las:matrix.org";
    github = "L-as";
    githubId = 22075344;
    keys = [{
      fingerprint = "A093 EA17 F450 D4D1 60A0  1194 AC45 8A7D 1087 D025";
    }];
  };
  l3af = {
    name = "L3af";
    email = "L3afMeAlon3@gmail.com";

    matrix = "@L3afMe:matrix.org";
    github = "L3afMe";
    githubId = 72546287;
  };
  laalsaas = {
    name = "laalsaas";
    email = "laalsaas@systemli.org";

    github = "laalsaas";
    githubId = 43275254;
  };
  lach = {
    name = "Yaroslav Bolyukin";
    email = "iam@lach.pw";

    github = "CertainLach";
    githubId = 6235312;
    keys = [{
      fingerprint = "323C 95B5 DBF7 2D74 8570  C0B7 40B5 D694 8143 175F";
    }];
  };
  lafrenierejm = {
    name = "Joseph LaFreniere";
    email = "joseph@lafreniere.xyz";

    github = "lafrenierejm";
    githubId = 11155300;
    keys = [{
      fingerprint = "0375 DD9A EDD1 68A3 ADA3  9EBA EE23 6AA0 141E FCA3";
    }];
  };
  laikq = {
    name = "Gwendolyn Quasebarth";
    email = "gwen@quasebarth.de";

    github = "laikq";
    githubId = 55911173;
  };
  lambda-11235 = {
    name = "Taran Lynn";
    email = "taranlynn0@gmail.com";

    github = "lambda-11235";
    githubId = 16354815;
  };
  lammermann = {
    name = "Benjamin Kober";
    email = "k.o.b.e.r@web.de";

    github = "lammermann";
    githubId = 695526;
  };
  larsr = {
    name = "Lars Rasmusson";
    email = "Lars.Rasmusson@gmail.com";

    github = "larsr";
    githubId = 182024;
  };
  lasandell = {
    name = "Luke Sandell";
    email = "lasandell@gmail.com";

    github = "lasandell";
    githubId = 2034420;
  };
  lassulus = {
    name = "Lassulus";
    email = "lassulus@gmail.com";

    matrix = "@lassulus:lassul.us";
    github = "Lassulus";
    githubId = 621759;
  };
  layus = {
    name = "Guillaume Maudoux";
    email = "layus.on@gmail.com";

    github = "layus";
    githubId = 632767;
  };
  lblasc = {
    name = "Luka Blaskovic";
    email = "lblasc@znode.net";

    github = "lblasc";
    githubId = 32152;
  };
  lbpdt = {
    name = "Louis Blin";
    email = "nix@pdtpartners.com";

    github = "lbpdt";
    githubId = 45168934;
  };
  lde = {
    name = "Lilian Deloche";
    email = "lilian.deloche@puck.fr";

    github = "lde";
    githubId = 1447020;
  };
  ldelelis = {
    name = "Lucio Delelis";
    email = "ldelelis@est.frba.utn.edu.ar";

    github = "ldelelis";
    githubId = 20250323;
  };
  ldenefle = {
    name = "Lucas Denefle";
    email = "ldenefle@gmail.com";

    github = "ldenefle";
    githubId = 20558127;
  };
  ldesgoui = {
    name = "Lucas Desgouilles";
    email = "ldesgoui@gmail.com";

    matrix = "@ldesgoui:matrix.org";
    github = "ldesgoui";
    githubId = 2472678;
  };
  league = {
    name = "Christopher League";
    email = "league@contrapunctus.net";

    github = "league";
    githubId = 50286;
  };
  leahneukirchen = {
    name = "Leah Neukirchen";
    email = "leah@vuxu.org";

    github = "leahneukirchen";
    githubId = 139;
  };
  lebastr = {
    name = "Alexander Lebedev";
    email = "lebastr@gmail.com";

    github = "lebastr";
    githubId = 887072;
  };
  ledif = {
    name = "Adam Fidel";
    email = "refuse@gmail.com";

    github = "ledif";
    githubId = 307744;
  };
  leemachin = {
    name = "Lee Machin";
    email = "me@mrl.ee";

    github = "leemeichin";
    githubId = 736291;
  };
  leenaars = {
    name = "Michiel Leenaars";
    email = "ml.software@leenaa.rs";

    github = "leenaars";
    githubId = 4158274;
  };
  leifhelm = {
    name = "Jakob Leifhelm";
    email = "jakob.leifhelm@gmail.com";

    github = "leifhelm";
    githubId = 31693262;
    keys = [{
      fingerprint = "4A82 F68D AC07 9FFD 8BF0  89C4 6817 AA02 3810 0822";
    }];
  };
  leixb = {
    name = "Aleix Boné";
    email = "abone9999+nixpkgs@gmail.com";

    matrix = "@leix_b:matrix.org";
    github = "Leixb";
    githubId = 17183803;
    keys = [{
      fingerprint = "63D3 F436 EDE8 7E1F 1292  24AF FC03 5BB2 BB28 E15D";
    }];
  };
  lejonet = {
    name = "Daniel Kuehn";
    email = "daniel@kuehn.se";

    github = "lejonet";
    githubId = 567634;
  };
  leo60228 = {
    name = "leo60228";
    email = "leo@60228.dev";

    matrix = "@leo60228:matrix.org";
    github = "leo60228";
    githubId = 8355305;
    keys = [{
      fingerprint = "5BE4 98D5 1C24 2CCD C21A  4604 AC6F 4BA0 78E6 7833";
    }];
  };
  leona = {
    name = "Leona Maroni";
    email = "nix@leona.is";

    github = "leona-ya";
    githubId = 11006031;
  };
  leonardoce = {
    name = "Leonardo Cecchi";
    email = "leonardo.cecchi@gmail.com";

    github = "leonardoce";
    githubId = 1572058;
  };
  leshainc = {
    name = "Alexey Nikashkin";
    email = "leshainc@fomalhaut.me";

    github = "LeshaInc";
    githubId = 42153076;
  };
  lesuisse = {
    name = "Thomas Gerbet";
    email = "thomas@gerbet.me";

    github = "LeSuisse";
    githubId = 737767;
  };
  lethalman = {
    name = "Luca Bruno";
    email = "lucabru@src.gnome.org";

    github = "lethalman";
    githubId = 480920;
  };
  leungbk = {
    name = "Brian Leung";
    email = "leungbk@mailfence.com";

    github = "leungbk";
    githubId = 29217594;
  };
  lewo = {
    name = "Antoine Eiche";
    email = "lewo@abesis.fr";

    matrix = "@lewo:matrix.org";
    github = "nlewo";
    githubId = 3425311;
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
    name = "Jade";
    email = "nix-maint@lfcode.ca";

    github = "lf-";
    githubId = 6652840;
  };
  lgcl = {
    name = "Leon Vack";
    email = "dev@lgcl.de";

    github = "LogicalOverflow";
    githubId = 5919957;
  };
  lheckemann = {
    name = "Linus Heckemann";
    email = "git@sphalerite.org";

    github = "lheckemann";
    githubId = 341954;
  };
  lhvwb = {
    name = "Nathaniel Baxter";
    email = "nathaniel.baxter@gmail.com";

    github = "nathanielbaxter";
    githubId = 307589;
  };
  liamdiprose = {
    name = "Liam Diprose";
    email = "liam@liamdiprose.com";

    github = "liamdiprose";
    githubId = 1769386;
  };
  libjared = {
    name = "Jared Perry";
    email = "jared@perrycode.com";

    matrix = "@libjared:matrix.org";
    github = "libjared";
    githubId = 3746656;
  };
  liff = {
    name = "Olli Helenius";
    email = "liff@iki.fi";

    github = "liff";
    githubId = 124475;
  };
  lightbulbjim = {
    name = "Chris Rendle-Short";
    email = "chris@killred.net";

    github = "lightbulbjim";
    githubId = 4312404;
  };
  lightdiscord = {
    name = "Arnaud Pascal";
    email = "root@arnaud.sh";

    github = "lightdiscord";
    githubId = 24509182;
  };
  lightquantum = {
    name = "Yanning Chen";
    email = "self@lightquantum.me";

    matrix = "@self:lightquantum.me";
    github = "PhotonQuantum";
    githubId = 18749973;
  };
  lihop = {
    name = "Leroy Hopson";
    email = "nixos@leroy.geek.nz";

    github = "lihop";
    githubId = 3696783;
  };
  lilyball = {
    name = "Lily Ballard";
    email = "lily@sb.org";

    github = "lilyball";
    githubId = 714;
  };
  lilyinstarlight = {
    name = "Lily Foster";
    email = "lily@lily.flowers";

    matrix = "@lily:lily.flowers";
    github = "lilyinstarlight";
    githubId = 298109;
  };
  limeytexan = {
    name = "Michael Brantley";
    email = "limeytexan@gmail.com";

    github = "limeytexan";
    githubId = 36448130;
  };
  linc01n = {
    name = "Lincoln Lee";
    email = "git@lincoln.hk";

    github = "linc01n";
    githubId = 667272;
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
    name = "Linquize";
    email = "linquize@yahoo.com.hk";

    github = "linquize";
    githubId = 791115;
  };
  linsui = {
    name = "linsui";
    email = "linsui555@gmail.com";

    github = "linsui";
    githubId = 36977733;
  };
  linus = {
    name = "Linus Arver";
    email = "linusarver@gmail.com";

    github = "listx";
    githubId = 725613;
  };
  lionello = {
    name = "Lionello Lunesu";
    email = "lio@lunesu.com";

    github = "lionello";
    githubId = 591860;
  };
  livnev = {
    name = "Lev Livnev";
    email = "lev@liv.nev.org.uk";

    github = "livnev";
    githubId = 3964494;
    keys = [{
      fingerprint = "74F5 E5CC 19D3 B5CB 608F  6124 68FF 81E6 A785 0F49";
    }];
  };
  lluchs = {
    name = "Lukas Werling";
    email = "lukas.werling@gmail.com";

    github = "lluchs";
    githubId = 516527;
  };
  lnl7 = {
    name = "Daiderd Jordan";
    email = "daiderd@gmail.com";

    github = "LnL7";
    githubId = 689294;
  };
  lo1tuma = {
    name = "Mathias Schreck";
    email = "schreck.mathias@gmail.com";

    github = "lo1tuma";
    githubId = 169170;
  };
  locallycompact = {
    name = "Daniel Firth";
    email = "dan.firth@homotopic.tech";

    github = "locallycompact";
    githubId = 1267527;
  };
  lockejan = {
    name = "Jan Schmitt";
    email = "git@smittie.de";

    matrix = "@jan:smittie.de";
    github = "lockejan";
    githubId = 25434434;
    keys = [{
      fingerprint = "1763 9903 2D7C 5B82 5D5A  0EAD A2BC 3C6F 1435 1991";
    }];
  };
  lodi = {
    name = "Anthony Lodi";
    email = "anthony.lodi@gmail.com";

    github = "lodi";
    githubId = 918448;
  };
  loewenheim = {
    name = "Sebastian Zivota";
    email = "loewenheim@mailbox.org";

    github = "loewenheim";
    githubId = 7622248;
  };
  logo = {
    name = "Isaac Silverstein";
    email = "logo4poop@protonmail.com";

    matrix = "@logo4poop:matrix.org";
    github = "logo4poop";
    githubId = 24994565;
  };
  loicreynier = {
    name = "Loïc Reynier";
    email = "loic@loicreynier.fr";

    github = "loicreynier";
    githubId = 88983487;
  };
  lom = {
    name = "legendofmiracles";
    email = "legendofmiracles@protonmail.com";

    matrix = "@legendofmiracles:matrix.org";
    github = "legendofmiracles";
    githubId = 30902201;
    keys = [{
      fingerprint = "CC50 F82C 985D 2679 0703  AF15 19B0 82B3 DEFE 5451";
    }];
  };
  lopsided98 = {
    name = "Ben Wolsieffer";
    email = "benwolsieffer@gmail.com";

    github = "lopsided98";
    githubId = 5624721;
  };
  lorenzleutgeb = {
    name = "Lorenz Leutgeb";
    email = "lorenz@leutgeb.xyz";

    github = "lorenzleutgeb";
    githubId = 542154;
  };
  loskutov = {
    name = "Ignat Loskutov";
    email = "ignat.loskutov@gmail.com";

    github = "loskutov";
    githubId = 1202012;
  };
  lostnet = {
    name = "Will Young";
    email = "lost.networking@gmail.com";

    github = "lostnet";
    githubId = 1422781;
  };
  louisdk1 = {
    name = "Louis Tim Larsen";
    email = "louis@louis.dk";

    github = "LouisDK1";
    githubId = 4969294;
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
  lovek323 = {
    name = "Jason O'Conal";
    email = "jason@oconal.id.au";

    github = "lovek323";
    githubId = 265084;
  };
  lovesegfault = {
    name = "Bernardo Meurer";
    email = "meurerbernardo@gmail.com";

    matrix = "@lovesegfault:matrix.org";
    github = "lovesegfault";
    githubId = 7243783;
    keys = [{
      fingerprint = "F193 7596 57D5 6DA4 CCD4  786B F4C0 D53B 8D14 C246";
    }];
  };
  lowfatcomputing = {
    name = "Andreas Wagner";
    email = "andreas.wagner@lowfatcomputing.org";

    github = "lowfatcomputing";
    githubId = 10626;
  };
  lrewega = {
    name = "Luke Rewega";
    email = "lrewega@c32.ca";

    github = "lrewega";
    githubId = 639066;
  };
  lromor = {
    name = "Leonardo Romor";
    email = "leonardo.romor@gmail.com";

    github = "lromor";
    githubId = 1597330;
  };
  lschuermann = {
    name = "Leon Schuermann";
    email = "leon.git@is.currently.online";

    matrix = "@leons:is.currently.online";
    github = "lschuermann";
    githubId = 5341193;
  };
  lsix = {
    name = "Lancelot SIX";
    email = "lsix@lancelotsix.com";

    github = "lsix";
    githubId = 724339;
  };
  ltavard = {
    name = "Laure Tavard";
    email = "laure.tavard@univ-grenoble-alpes.fr";

    github = "ltavard";
    githubId = 8555953;
  };
  luc65r = {
    name = "Lucas Ransan";
    email = "lucas@ransan.tk";

    github = "luc65r";
    githubId = 59375051;
  };
  lucasew = {
    name = "Lucas Eduardo Wendt";
    email = "lucas59356@gmail.com";

    github = "lucasew";
    githubId = 15693688;
  };
  lucc = {
    name = "Lucas Hoffmann";
    email = "lucc+nix@posteo.de";

    github = "lucc";
    githubId = 1104419;
  };
  lucperkins = {
    name = "Luc Perkins";
    email = "lucperkins@gmail.com";

    github = "lucperkins";
    githubId = 1523104;
  };
  lucus16 = {
    name = "Lars Jellema";
    email = "lars.jellema@gmail.com";

    github = "Lucus16";
    githubId = 2487922;
  };
  ludo = {
    name = "Ludovic Courtès";
    email = "ludo@gnu.org";

    github = "civodul";
    githubId = 1168435;
  };
  lufia = {
    name = "Kyohei Kadota";
    email = "lufia@lufia.org";

    github = "lufia";
    githubId = 1784379;
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
  luis = {
    name = "Luis Hebendanz";
    email = "luis.nixos@gmail.com";

    github = "Luis-Hebendanz";
    githubId = 22085373;
  };
  luispedro = {
    name = "Luis Pedro Coelho";
    email = "luis@luispedro.org";

    github = "luispedro";
    githubId = 79334;
  };
  luizribeiro = {
    name = "Luiz Ribeiro";
    email = "nixpkgs@l9o.dev";

    matrix = "@luizribeiro:matrix.org";
    github = "luizribeiro";
    githubId = 112069;
    keys = [{
      fingerprint = "97A0 AE5E 03F3 499B 7D7A  65C6 76A4 1432 37EF 5817";
    }];
  };
  lukeadams = {
    name = "Luke Adams";
    email = "luke.adams@belljar.io";

    github = "lukeadams";
    githubId = 3508077;
  };
  lukebfox = {
    name = "Luke Bentley-Fox";
    email = "lbentley-fox1@sheffield.ac.uk";

    github = "lukebfox";
    githubId = 34683288;
  };
  lukegb = {
    name = "Luke Granger-Brown";
    email = "nix@lukegb.com";

    matrix = "@lukegb:zxcvbnm.ninja";
    github = "lukegb";
    githubId = 246745;
  };
  lukego = {
    name = "Luke Gorrie";
    email = "luke@snabb.co";

    github = "lukego";
    githubId = 13791;
  };
  luker = {
    name = "Luca Fulchir";
    email = "luker@fenrirproject.org";

    github = "LucaFulchir";
    githubId = 2486026;
  };
  lumi = {
    name = "lumi";
    email = "lumi@pew.im";

    github = "lumi-me-not";
    githubId = 26020062;
  };
  lunarequest = {
    name = "Luna D Dragon";
    email = "nullarequest@vivlaid.net";

    github = "Lunarequest";
    githubId = 30698906;
  };
  lunik1 = {
    name = "Corin Hoad";
    email = "ch.nixpkgs@themaw.xyz";

    matrix = "@lunik1:lunik.one";
    github = "lunik1";
    githubId = 13547699;
    keys = [{
      fingerprint = "BA3A 5886 AE6D 526E 20B4  57D6 6A37 DF94 8318 8492";
    }];
  };
  LunNova = {
    name = "Luna Nova";
    email = "nixpkgs-maintainer@lunnova.dev";

    github = "LunNova";
    githubId = 782440;
  };
  lux = {
    name = "Lux";
    email = "lux@lux.name";

    matrix = "@lux:ontheblueplanet.com";
    github = "luxferresum";
    githubId = 1208273;
  };
  luz = {
    name = "Luz";
    email = "luz666@daum.net";

    github = "Luz";
    githubId = 208297;
  };
  lw = {
    name = "Sergey Sofeychuk";
    email = "lw@fmap.me";

    github = "lolwat97";
    githubId = 2057309;
  };
  lxea = {
    name = "Alex McGrath";
    email = "nix@amk.ie";

    github = "lxea";
    githubId = 7910815;
  };
  lynty = {
    name = "Lynn Dong";
    email = "ltdong93+nix@gmail.com";

    github = "Lynty";
    githubId = 39707188;
  };
  m00wl = {
    name = "Moritz Lumme";
    email = "moritz.lumme@gmail.com";

    github = "m00wl";
    githubId = 46034439;
  };
  m1cr0man = {
    name = "Lucas Savva";
    email = "lucas+nix@m1cr0man.com";

    github = "m1cr0man";
    githubId = 3044438;
  };
  ma27 = {
    name = "Maximilian Bosch";
    email = "maximilian@mbosch.me";

    matrix = "@ma27:nicht-so.sexy";
    github = "Ma27";
    githubId = 6025220;
  };
  ma9e = {
    name = "Sean Haugh";
    email = "sean@lfo.team";

    github = "furrycatherder";
    githubId = 36235154;
  };
  maaslalani = {
    name = "Maas Lalani";
    email = "maaslalani0@gmail.com";

    github = "maaslalani";
    githubId = 42545625;
  };
  macalinao = {
    name = "Ian Macalinao";
    email = "me@ianm.com";

    github = "macalinao";
    githubId = 401263;
    keys = [{
      fingerprint = "1147 43F1 E707 6F3E 6F4B  2C96 B9A8 B592 F126 F8E8";
    }];
  };
  maddiethecafebabe = {
    name = "Madeline S.";
    email = "maddie@cafebabe.date";

    github = "maddiethecafebabe";
    githubId = 75337286;
  };
  madjar = {
    name = "Georges Dubus";
    email = "georges.dubus@compiletoi.net";

    github = "madjar";
    githubId = 109141;
  };
  madonius = {
    name = "madonius";
    email = "nixos@madoni.us";

    matrix = "@madonius:entropia.de";
    github = "madonius";
    githubId = 1246752;
  };
  Madouura = {
    name = "Madoura";
    email = "madouura@gmail.com";

    github = "Madouura";
    githubId = 93990818;
  };
  mafo = {
    name = "Marc Fontaine";
    email = "Marc.Fontaine@gmx.de";

    github = "MarcFontaine";
    githubId = 1433367;
  };
  magenbluten = {
    name = "magenbluten";
    email = "magenbluten@codemonkey.cc";

    github = "magenbluten";
    githubId = 1140462;
  };
  maggesi = {
    name = "Marco Maggesi";
    email = "marco.maggesi@gmail.com";

    github = "maggesi";
    githubId = 1809783;
  };
  magnetophon = {
    name = "Bart Brouns";
    email = "bart@magnetophon.nl";

    github = "magnetophon";
    githubId = 7645711;
  };
  magnouvean = {
    name = "Maxwell Berg";
    email = "rg0zjsyh@anonaddy.me";

    github = "magnouvean";
    githubId = 85435692;
  };
  mahe = {
    name = "Matthias Herrmann";
    email = "matthias.mh.herrmann@gmail.com";

    github = "2chilled";
    githubId = 1238350;
  };
  majesticmullet = {
    name = "Tom Ho";
    email = "hoccthomas@gmail.com.au";

    github = "MajesticMullet";
    githubId = 31056089;
  };
  majewsky = {
    name = "Stefan Majewsky";
    email = "majewsky@gmx.net";

    github = "majewsky";
    githubId = 24696;
  };
  majiir = {
    name = "Majiir Paktu";
    email = "majiir@nabaal.net";

    github = "Majiir";
    githubId = 963511;
  };
  makefu = {
    name = "Felix Richter";
    email = "makefu@syntax-fehler.de";

    github = "makefu";
    githubId = 115218;
  };
  malbarbo = {
    name = "Marco A L Barbosa";
    email = "malbarbo@gmail.com";

    github = "malbarbo";
    githubId = 1678126;
  };
  malo = {
    name = "Malo Bourgon";
    email = "mbourgon@gmail.com";

    github = "malob";
    githubId = 2914269;
  };
  malvo = {
    name = "Malte Voos";
    email = "malte@malvo.org";

    github = "malte-v";
    githubId = 34393802;
  };
  malyn = {
    name = "Michael Alyn Miller";
    email = "malyn@strangeGizmo.com";

    github = "malyn";
    githubId = 346094;
  };
  manojkarthick = {
    name = "Manoj Karthick";
    email = "smanojkarthick@gmail.com";

    github = "manojkarthick";
    githubId = 7802795;
  };
  manveru = {
    name = "Michael Fellinger";
    email = "m.fellinger@gmail.com";

    matrix = "@manveru:matrix.org";
    github = "manveru";
    githubId = 3507;
  };
  maralorn = {
    name = "maralorn";
    email = "mail@maralorn.de";

    matrix = "@maralorn:maralorn.de";
    github = "maralorn";
    githubId = 1651325;
  };
  marcus7070 = {
    name = "Marcus Boyd";
    email = "marcus@geosol.com.au";

    github = "marcus7070";
    githubId = 50230945;
  };
  marcweber = {
    name = "Marc Weber";
    email = "marco-oweber@gmx.de";

    github = "MarcWeber";
    githubId = 34086;
  };
  marenz = {
    name = "Markus Schmidl";
    email = "marenz@arkom.men";

    github = "marenz2569";
    githubId = 12773269;
  };
  mariaa144 = {
    name = "Maria";
    email = "speechguard_intensivist@aleeas.com";

    github = "mariaa144";
    githubId = 105451387;
  };
  marijanp = {
    name = "Marijan Petričević";
    email = "marijan.petricevic94@gmail.com";

    github = "marijanp";
    githubId = 13599169;
  };
  marius851000 = {
    name = "Marius David";
    email = "mariusdavid@laposte.net";

    github = "marius851000";
    githubId = 22586596;
  };
  markus1189 = {
    name = "Markus Hauck";
    email = "markus1189@gmail.com";

    github = "markus1189";
    githubId = 591567;
  };
  markuskowa = {
    name = "Markus Kowalewski";
    email = "markus.kowalewski@gmail.com";

    github = "markuskowa";
    githubId = 26470037;
  };
  marsam = {
    name = "Mario Rodas";
    email = "marsam@users.noreply.github.com";

    github = "marsam";
    githubId = 65531;
  };
  marsupialgutz = {
    name = "Marshall Arruda";
    email = "mars@possums.xyz";

    github = "pupbrained";
    githubId = 33522919;
  };
  martfont = {
    name = "Martino Fontana";
    email = "tinozzo123@tutanota.com";

    github = "SuperSamus";
    githubId = 40663462;
  };
  martijnvermaat = {
    name = "Martijn Vermaat";
    email = "martijn@vermaat.name";

    github = "martijnvermaat";
    githubId = 623509;
  };
  martinetd = {
    name = "Dominique Martinet";
    email = "f.ktfhrvnznqxacf@noclue.notk.org";

    github = "martinetd";
    githubId = 1729331;
  };
  martingms = {
    name = "Martin Gammelsæter";
    email = "martin@mg.am";

    github = "martingms";
    githubId = 458783;
  };
  marzipankaiser = {
    name = "Marcial Gaißert";
    email = "nixos@gaisseml.de";

    github = "marzipankaiser";
    githubId = 2551444;
    keys = [{
      fingerprint = "B573 5118 0375 A872 FBBF  7770 B629 036B E399 EEE9";
    }];
  };
  masaeedu = {
    name = "Asad Saeeduddin";
    email = "masaeedu@gmail.com";

    github = "masaeedu";
    githubId = 3674056;
  };
  masipcat = {
    name = "Jordi Masip";
    email = "jordi@masip.cat";

    github = "masipcat";
    githubId = 775189;
  };
  MaskedBelgian = {
    name = "Michael Colicchia";
    email = "michael.colicchia@imio.be";

    github = "MaskedBelgian";
    githubId = 29855073;
  };
  matejc = {
    name = "Matej Cotman";
    email = "cotman.matej@gmail.com";

    github = "matejc";
    githubId = 854770;
  };
  math-42 = {
    name = "Matheus Vieira";
    email = "matheus.4200@gmail.com";

    github = "Math-42";
    githubId = 43853194;
  };
  mathnerd314 = {
    name = "Mathnerd314";
    email = "mathnerd314.gph+hs@gmail.com";

    github = "Mathnerd314";
    githubId = 322214;
  };
  matklad = {
    name = "matklad";
    email = "aleksey.kladov@gmail.com";

    github = "matklad";
    githubId = 1711539;
  };
  matrss = {
    name = "Matthias Riße";
    email = "matthias.risze@t-online.de";

    github = "matrss";
    githubId = 9308656;
  };
  matt-snider = {
    name = "Matt Snider";
    email = "matt.snider@protonmail.com";

    github = "matt-snider";
    githubId = 11810057;
  };
  mattchrist = {
    name = "Matt Christ";
    email = "nixpkgs-matt@christ.systems";

    github = "mattchrist";
    githubId = 952712;
  };
  matthewbauer = {
    name = "Matthew Bauer";
    email = "mjbauer95@gmail.com";

    github = "matthewbauer";
    githubId = 19036;
  };
  matthewcroughan = {
    name = "Matthew Croughan";
    email = "matt@croughan.sh";

    github = "MatthewCroughan";
    githubId = 26458780;
  };
  matthewpi = {
    name = "Matthew Penner";
    email = "me+nix@matthewp.io";

    github = "matthewpi";
    githubId = 26559841;
    keys = [{
      fingerprint = "5118 F1CC B7B0 6C17 4DD1  5267 3131 1906 AD4C F6D6";
    }];
  };
  matthiasbenaets = {
    name = "Matthias Benaets";
    email = "matthias.benaets@gmail.com";

    github = "MatthiasBenaets";
    githubId = 89214559;
  };
  matthiasbeyer = {
    name = "Matthias Beyer";
    email = "mail@beyermatthias.de";

    matrix = "@musicmatze:beyermatthi.as";
    github = "matthiasbeyer";
    githubId = 427866;
  };
  MatthieuBarthel = {
    name = "Matthieu Barthel";
    email = "matthieu@imatt.ch";

    github = "MatthieuBarthel";
    githubId = 435534;
    keys = [{
      fingerprint = "80EB 0F2B 484A BB80 7BEF  4145 BA23 F10E AADC 2E26";
    }];
  };
  matthuszagh = {
    name = "Matt Huszagh";
    email = "huszaghmatt@gmail.com";

    github = "matthuszagh";
    githubId = 7377393;
  };
  matti-kariluoma = {
    name = "Matti Kariluoma";
    email = "matti@kariluo.ma";

    github = "matti-kariluoma";
    githubId = 279868;
  };
  maurer = {
    name = "Matthew Maurer";
    email = "matthew.r.maurer+nix@gmail.com";

    github = "maurer";
    githubId = 136037;
  };
  mausch = {
    name = "Mauricio Scheffer";
    email = "mauricioscheffer@gmail.com";

    github = "mausch";
    githubId = 95194;
  };
  max-niederman = {
    name = "Max Niederman";
    email = "max@maxniederman.com";

    github = "max-niederman";
    githubId = 19580458;
    keys = [{
      fingerprint = "1DE4 424D BF77 1192 5DC4  CF5E 9AED 8814 81D8 444E";
    }];
  };
  maxbrunet = {
    name = "Maxime Brunet";
    email = "max@brnt.mx";

    github = "maxbrunet";
    githubId = 32458727;
    keys = [{
      fingerprint = "E9A2 EE26 EAC6 B3ED 6C10  61F3 4379 62FF 87EC FE2B";
    }];
  };
  maxdamantus = {
    name = "Max Zerzouri";
    email = "maxdamantus@gmail.com";

    github = "Maxdamantus";
    githubId = 502805;
  };
  maxeaubrey = {
    name = "Maxine Aubrey";
    email = "maxeaubrey@gmail.com";

    github = "maxeaubrey";
    githubId = 35892750;
  };
  maxhbr = {
    name = "Maximilian Huber";
    email = "nixos@maxhbr.dev";

    github = "maxhbr";
    githubId = 1187050;
  };
  maxhero = {
    name = "Marcelo A. de L. Santos";
    email = "contact@maxhero.dev";

    github = "themaxhero";
    githubId = 4708337;
  };
  maxhille = {
    name = "Max Hille";
    email = "mh@lambdasoup.com";

    github = "maxhille";
    githubId = 693447;
  };
  maximsmol = {
    name = "Max Smolin";
    email = "maximsmol@gmail.com";

    github = "maximsmol";
    githubId = 1472826;
  };
  maxux = {
    name = "Maxime Daniel";
    email = "root@maxux.net";

    github = "maxux";
    githubId = 4141584;
  };
  maxwell-lt = {
    name = "Maxwell L-T";
    email = "maxwell.lt@live.com";

    github = "maxwell-lt";
    githubId = 17859747;
  };
  maxwilson = {
    name = "Max Wilson";
    email = "nixpkgs@maxwilson.dev";

    github = "mwilsoncoding";
    githubId = 43796009;
  };
  maxxk = {
    name = "Maxim Krivchikov";
    email = "maxim.krivchikov@gmail.com";

    github = "maxxk";
    githubId = 1191859;
  };
  MayNiklas = {
    name = "Niklas Steffen";
    email = "info@niklas-steffen.de";

    github = "MayNiklas";
    githubId = 44636701;
  };
  mazurel = {
    name = "Mateusz Mazur";
    email = "mateusz.mazur@yahoo.com";

    github = "Mazurel";
    githubId = 22836301;
  };
  mbaeten = {
    name = "M. Baeten";
    email = "mbaeten@users.noreply.github.com";

    github = "mbaeten";
    githubId = 2649304;
  };
  mbaillie = {
    name = "Martin Baillie";
    email = "martin@baillie.id";

    github = "martinbaillie";
    githubId = 613740;
  };
  mbbx6spp = {
    name = "Susan Potter";
    email = "me@susanpotter.net";

    github = "mbbx6spp";
    githubId = 564;
  };
  mbe = {
    name = "Brandon Edens";
    email = "brandonedens@gmail.com";

    github = "brandonedens";
    githubId = 396449;
  };
  mbode = {
    name = "Maximilian Bode";
    email = "maxbode@gmail.com";

    github = "mbode";
    githubId = 9051309;
  };
  mboes = {
    name = "Mathieu Boespflug";
    email = "mboes@tweag.net";

    github = "mboes";
    githubId = 51356;
  };
  mbprtpmnr = {
    name = "mbprtpmnr";
    email = "mbprtpmnr@pm.me";

    github = "mbprtpmnr";
    githubId = 88109321;
  };
  mbrgm = {
    name = "Marius Bergmann";
    email = "marius@yeai.de";

    github = "mbrgm";
    githubId = 2971615;
  };
  mcaju = {
    name = "Mihai-Drosi Caju";
    email = "cajum.bugs@yandex.com";

    github = "CajuM";
    githubId = 10420834;
  };
  mcbeth = {
    name = "Jeffrey Brent McBeth";
    email = "mcbeth@broggs.org";

    github = "mcbeth";
    githubId = 683809;
  };
  mcmtroffaes = {
    name = "Matthias C. M. Troffaes";
    email = "matthias.troffaes@gmail.com";

    github = "mcmtroffaes";
    githubId = 158568;
  };
  McSinyx = {
    name = "Nguyễn Gia Phong";
    email = "mcsinyx@disroot.org";

    github = "McSinyx";
    githubId = 13689192;
    keys = [{
      fingerprint = "E90E 11B8 0493 343B 6132  E394 2714 8B2C 06A2 224B";
    }];
  };
  mcwitt = {
    name = "Matt Wittmann";
    email = "mcwitt@gmail.com";

    github = "mcwitt";
    githubId = 319411;
  };
  mdaiter = {
    name = "Matthew S. Daiter";
    email = "mdaiter8121@gmail.com";

    github = "mdaiter";
    githubId = 1377571;
  };
  mdarocha = {
    name = "Marek Darocha";
    email = "marek@mdarocha.pl";

    github = "mdarocha";
    githubId = 11572618;
  };
  mdevlamynck = {
    name = "Matthias Devlamynck";
    email = "matthias.devlamynck@mailoo.org";

    github = "mdevlamynck";
    githubId = 4378377;
  };
  mdlayher = {
    name = "Matt Layher";
    email = "mdlayher@gmail.com";

    github = "mdlayher";
    githubId = 1926905;
    keys = [{
      fingerprint = "D709 03C8 0BE9 ACDC 14F0  3BFB 77BF E531 397E DE94";
    }];
  };
  meain = {
    name = "Abin Simon";
    email = "mail@meain.io";

    matrix = "@meain:matrix.org";
    github = "meain";
    githubId = 14259816;
  };
  meatcar = {
    name = "Denys Pavlov";
    email = "nixpkgs@denys.me";

    github = "meatcar";
    githubId = 191622;
  };
  meditans = {
    name = "Carlo Nucera";
    email = "meditans@gmail.com";

    github = "meditans";
    githubId = 4641445;
  };
  megheaiulian = {
    name = "Meghea Iulian";
    email = "iulian.meghea@gmail.com";

    github = "megheaiulian";
    githubId = 1788114;
  };
  meisternu = {
    name = "Matt Miemiec";
    email = "meister@krutt.org";

    github = "meisternu";
    githubId = 8263431;
  };
  melchips = {
    name = "Francois Truphemus";
    email = "truphemus.francois@gmail.com";

    github = "melchips";
    githubId = 365721;
  };
  melias122 = {
    name = "Martin Elias";
    email = "martin+nixpkgs@elias.sx";

    github = "melias122";
    githubId = 1027766;
  };
  melkor333 = {
    name = "Samuel Ruprecht";
    email = "samuel@ton-kunst.ch";

    github = "Melkor333";
    githubId = 6412377;
  };
  melling = {
    name = "Matt Melling";
    email = "mattmelling@fastmail.com";

    github = "mattmelling";
    githubId = 1215331;
  };
  melsigl = {
    name = "Melanie B. Sigl";
    email = "melanie.bianca.sigl@gmail.com";

    github = "melsigl";
    githubId = 15093162;
  };
  mephistophiles = {
    name = "Maxim Zhukov";
    email = "mussitantesmortem@gmail.com";

    github = "Mephistophiles";
    githubId = 4850908;
  };
  mfossen = {
    name = "Mitchell Fossen";
    email = "msfossen@gmail.com";

    github = "mfossen";
    githubId = 3300322;
  };
  mgdelacroix = {
    name = "Miguel de la Cruz";
    email = "mgdelacroix@gmail.com";

    github = "mgdelacroix";
    githubId = 223323;
  };
  mgdm = {
    name = "Michael Maclean";
    email = "michael@mgdm.net";

    github = "mgdm";
    githubId = 71893;
  };
  mglolenstine = {
    name = "MGlolenstine";
    email = "mglolenstine@gmail.com";

    matrix = "@mglolenstine:matrix.org";
    github = "MGlolenstine";
    githubId = 9406770;
  };
  mgregoire = {
    name = "Gregoire Martinache";
    email = "gregoire@martinache.net";

    github = "M-Gregoire";
    githubId = 9469313;
  };
  mgttlinger = {
    name = "Merlin Humml";
    email = "megoettlinger@gmail.com";

    github = "mgttlinger";
    githubId = 5120487;
  };
  mguentner = {
    name = "Maximilian Güntner";
    email = "code@klandest.in";

    github = "mguentner";
    githubId = 668926;
  };
  mh = {
    name = "Markus Heinrich";
    email = "68288772+markus-heinrich@users.noreply.github.com";

    github = "markus-heinrich";
    githubId = 68288772;
  };
  mh182 = {
    name = "Max Hofer";
    email = "mh182@chello.at";

    github = "mh182";
    githubId = 9980864;
  };
  mhaselsteiner = {
    name = "Magdalena Haselsteiner";
    email = "magdalena.haselsteiner@gmx.at";

    github = "mhaselsteiner";
    githubId = 20536514;
  };
  miangraham = {
    name = "M. Ian Graham";
    email = "miangraham@users.noreply.github.com";

    github = "miangraham";
    githubId = 704580;
    keys = [{
      fingerprint = "8CE3 2906 516F C4D8 D373  308A E189 648A 55F5 9A9F";
    }];
  };
  mic92 = {
    name = "Jörg Thalheim";
    email = "joerg@thalheim.io";

    matrix = "@mic92:nixos.dev";
    github = "Mic92";
    githubId = 96200;
    keys = [{
      fingerprint = "3DEE 1C55 6E1C 3DC5 54F5  875A 003F 2096 411B 5F92";
    }];
  };
  michaeladler = {
    name = "Michael Adler";
    email = "therisen06@gmail.com";

    github = "michaeladler";
    githubId = 1575834;
  };
  michaelBelsanti = {
    name = "Mike Belsanti";
    email = "mbels03@protonmail.com";

    github = "michaelBelsanti";
    githubId = 62124625;
  };
  michaelpj = {
    name = "Michael Peyton Jones";
    email = "michaelpj@gmail.com";

    github = "michaelpj";
    githubId = 1699466;
  };
  michalrus = {
    name = "Michal Rus";
    email = "m@michalrus.com";

    github = "michalrus";
    githubId = 4366292;
  };
  michelk = {
    name = "Michel Kuhlmann";
    email = "michel@kuhlmanns.info";

    github = "michelk";
    githubId = 1404919;
  };
  michojel = {
    name = "Michal Minář";
    email = "mic.liamg@gmail.com";

    github = "michojel";
    githubId = 21156022;
  };
  michzappa = {
    name = "Michael Zappa";
    email = "me@michzappa.com";

    github = "michzappa";
    githubId = 59343378;
  };
  mickours = {
    name = "Michael Mercier";
    email = "mickours@gmail.com<";

    github = "mickours";
    githubId = 837312;
  };
  midchildan = {
    name = "midchildan";
    email = "git@midchildan.org";

    matrix = "@midchildan:matrix.org";
    github = "midchildan";
    githubId = 7343721;
    keys = [{
      fingerprint = "FEF0 AE2D 5449 3482 5F06  40AA 186A 1EDA C5C6 3F83";
    }];
  };
  mightyiam = {
    name = "Shahar Dawn Or";
    email = "mightyiampresence@gmail.com";

    github = "mightyiam";
    githubId = 635591;
  };
  mihnea-s = {
    name = "Mihnea Stoian";
    email = "mihn.stn@gmail.com";

    github = "mihnea-s";
    githubId = 43088426;
  };
  mikefaille = {
    name = "Michaël Faille";
    email = "michael@faille.io";

    github = "mikefaille";
    githubId = 978196;
  };
  mikesperber = {
    name = "Mike Sperber";
    email = "sperber@deinprogramm.de";

    github = "mikesperber";
    githubId = 1387206;
  };
  mikoim = {
    name = "Eshin Kunishima";
    email = "ek@esh.ink";

    github = "mikoim";
    githubId = 3958340;
  };
  mikroskeem = {
    name = "Mark Vainomaa";
    email = "mikroskeem@mikroskeem.eu";

    github = "mikroskeem";
    githubId = 3490861;
    keys = [{
      fingerprint = "DB43 2895 CF68 F0CE D4B7  EF60 DA01 5B05 B5A1 1B22";
    }];
  };
  milahu = {
    name = "Milan Hauth";
    email = "milahu@gmail.com";

    github = "milahu";
    githubId = 12958815;
  };
  milesbreslin = {
    name = "Miles Breslin";
    email = "milesbreslin@gmail.com";

    github = "MilesBreslin";
    githubId = 38543128;
  };
  milibopp = {
    name = "Emilia Bopp";
    email = "contact@ebopp.de";

    github = "milibopp";
    githubId = 3098430;
  };
  millerjason = {
    name = "Jason Miller";
    email = "mailings-github@millerjason.com";

    github = "millerjason";
    githubId = 7610974;
  };
  milogert = {
    name = "Milo Gertjejansen";
    email = "milo@milogert.com";

    github = "milogert";
    githubId = 5378535;
  };
  mimame = {
    name = "Miguel Madrid Mencía";
    email = "miguel.madrid.mencia@gmail.com";

    github = "mimame";
    githubId = 3269878;
  };
  mindavi = {
    name = "Rick van Schijndel";
    email = "rol3517@gmail.com";

    github = "Mindavi";
    githubId = 9799623;
  };
  minijackson = {
    name = "Rémi Nicole";
    email = "minijackson@riseup.net";

    github = "minijackson";
    githubId = 1200507;
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
    name = "Armin Leuprecht";
    email = "armin.leuprecht@uni-graz.at";

    github = "mir06";
    githubId = 8479244;
  };
  mirdhyn = {
    name = "Merlin Gaillard";
    email = "mirdhyn@gmail.com";

    github = "mirdhyn";
    githubId = 149558;
  };
  mirrexagon = {
    name = "Andrew Abbott";
    email = "mirrexagon@mirrexagon.com";

    github = "mirrexagon";
    githubId = 1776903;
  };
  mislavzanic = {
    name = "Mislav Zanic";
    email = "mislavzanic3@gmail.com";

    github = "mislavzanic";
    githubId = 48838244;
  };
  misterio77 = {
    name = "Gabriel Fontes";
    email = "eu@misterio.me";

    matrix = "@misterio:matrix.org";
    github = "Misterio77";
    githubId = 5727578;
    keys = [{
      fingerprint = "7088 C742 1873 E0DB 97FF  17C2 245C AB70 B4C2 25E9";
    }];
  };
  misuzu = {
    name = "misuzu";
    email = "bakalolka@gmail.com";

    github = "misuzu";
    githubId = 248143;
  };
  mitchmindtree = {
    name = "Mitchell Nordine";
    email = "mail@mitchellnordine.com";

    github = "mitchmindtree";
    githubId = 4587373;
  };
  mjanczyk = {
    name = "Marcin Janczyk";
    email = "m@dragonvr.pl";

    github = "mjanczyk";
    githubId = 1001112;
  };
  mjp = {
    name = "Mike Playle";
    email = "mike@mythik.co.uk";

    github = "MikePlayle";
    githubId = 16974598;
  };
  mkaito = {
    name = "Christian Höppner";
    email = "chris@mkaito.net";

    github = "mkaito";
    githubId = 20434;
  };
  mkazulak = {
    name = "Maciej Kazulak";
    email = "kazulakm@gmail.com";

    github = "mulderr";
    githubId = 5698461;
  };
  mkf = {
    name = "Michał Krzysztof Feiler";
    email = "m@mikf.pl";

    github = "mkf";
    githubId = 7753506;
    keys = [{
      fingerprint = "1E36 9940 CC7E 01C4 CFE8  F20A E35C 2D7C 2C6A C724";
    }];
  };
  mkg = {
    name = "Mark K Gardner";
    email = "mkg@vt.edu";

    github = "mkgvt";
    githubId = 22477669;
  };
  mkg20001 = {
    name = "Maciej Krüger";
    email = "mkg20001+nix@gmail.com";

    matrix = "@mkg20001:matrix.org";
    github = "mkg20001";
    githubId = 7735145;
    keys = [{
      fingerprint = "E90C BA34 55B3 6236 740C  038F 0D94 8CE1 9CF4 9C5F";
    }];
  };
  mktip = {
    name = "Mohammad Issa";
    email = "mo.issa.ok+nix@gmail.com";

    github = "mktip";
    githubId = 45905717;
    keys = [{
      fingerprint = "64BE BF11 96C3 DD7A 443E  8314 1DC0 82FA DE5B A863";
    }];
  };
  mlatus = {
    name = "mlatus";
    email = "wqseleven@gmail.com";

    github = "Ninlives";
    githubId = 17873203;
  };
  mlieberman85 = {
    name = "Michael Lieberman";
    email = "mlieberman85@gmail.com";

    github = "mlieberman85";
    githubId = 622577;
  };
  mlvzk = {
    name = "mlvzk";
    email = "mlvzk@users.noreply.github.com";

    github = "mlvzk";
    githubId = 44906333;
  };
  mmahut = {
    name = "Marek Mahut";
    email = "marek.mahut@gmail.com";

    github = "mmahut";
    githubId = 104795;
  };
  mmai = {
    name = "Henri Bourcereau";
    email = "henri.bourcereau@gmail.com";

    github = "mmai";
    githubId = 117842;
  };
  mmesch = {
    name = "Matthias Meschede";
    email = "mmesch@noreply.github.com";

    github = "MMesch";
    githubId = 2597803;
  };
  mmilata = {
    name = "Martin Milata";
    email = "martin@martinmilata.cz";

    github = "mmilata";
    githubId = 85857;
  };
  mmlb = {
    name = "Manuel Mendez";
    email = "manny@peekaboo.mmlb.icu";

    github = "mmlb";
    githubId = 708570;
  };
  mnacamura = {
    name = "Mitsuhiro Nakamura";
    email = "m.nacamura@gmail.com";

    github = "mnacamura";
    githubId = 45770;
  };
  moaxcp = {
    name = "John Mercier";
    email = "moaxcp@gmail.com";

    github = "moaxcp";
    githubId = 7831184;
  };
  modulistic = {
    name = "Pablo Costa";
    email = "modulistic@gmail.com";

    github = "modulistic";
    githubId = 1902456;
  };
  mog = {
    name = "Matthew O'Gorman";
    email = "mog-lists@rldn.net";

    github = "mogorman";
    githubId = 64710;
  };
  Mogria = {
    name = "Mogria";
    email = "m0gr14@gmail.com";

    github = "mogria";
    githubId = 754512;
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
    name = "Patrice Clement";
    email = "monsieurp@gentoo.org";

    github = "monsieurp";
    githubId = 350116;
  };
  montag451 = {
    name = "montag451";
    email = "montag451@laposte.net";

    github = "montag451";
    githubId = 249317;
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
    name = "Nathan Moos";
    email = "moosingin3space@gmail.com";

    github = "moosingin3space";
    githubId = 830082;
  };
  moredread = {
    name = "André-Patrick Bubel";
    email = "code@apb.name";

    github = "Moredread";
    githubId = 100848;
    keys = [{
      fingerprint = "4412 38AD CAD3 228D 876C  5455 118C E7C4 24B4 5728";
    }];
  };
  moretea = {
    name = "Maarten Hoogendoorn";
    email = "maarten@moretea.nl";

    github = "moretea";
    githubId = 99988;
  };
  MoritzBoehme = {
    name = "Moritz Böhme";
    email = "mail@moritzboeh.me";

    github = "MoritzBoehme";
    githubId = 42215704;
  };
  MostAwesomeDude = {
    name = "Corbin Simpson";
    email = "cds@corbinsimpson.com";

    github = "MostAwesomeDude";
    githubId = 118035;
  };
  mothsart = {
    name = "Jérémie Ferry";
    email = "jerem.ferry@gmail.com";

    github = "mothsART";
    githubId = 10601196;
  };
  mounium = {
    name = "Katona László";
    email = "muoniurn@gmail.com";

    github = "Mounium";
    githubId = 20026143;
  };
  MP2E = {
    name = "Cray Elliott";
    email = "MP2E@archlinux.us";

    github = "MP2E";
    githubId = 167708;
  };
  mpcsh = {
    name = "Mark Cohen";
    email = "m@mpc.sh";

    github = "mpcsh";
    githubId = 2894019;
  };
  mpickering = {
    name = "Matthew Pickering";
    email = "matthewtpickering@gmail.com";

    github = "mpickering";
    githubId = 1216657;
  };
  mpoquet = {
    name = "Millian Poquet";
    email = "millian.poquet@gmail.com";

    github = "mpoquet";
    githubId = 3502831;
  };
  mpscholten = {
    name = "Marc Scholten";
    email = "marc@digitallyinduced.com";

    github = "mpscholten";
    githubId = 2072185;
  };
  mredaelli = {
    name = "Massimo Redaelli";
    email = "massimo@typish.io";

    github = "mredaelli";
    githubId = 3073833;
  };
  mrkkrp = {
    name = "Mark Karpov";
    email = "markkarpov92@gmail.com";

    github = "mrkkrp";
    githubId = 8165792;
  };
  mrmebelman = {
    name = "Vladyslav Burzakovskyy";
    email = "burzakovskij@protonmail.com";

    github = "MrMebelMan";
    githubId = 15896005;
  };
  mrtarantoga = {
    name = "Götz Grimmer";
    email = "goetz-dev@web.de";

    github = "MrTarantoga";
    githubId = 53876219;
  };
  mrVanDalo = {
    name = "Ingolf Wanger";
    email = "contact@ingolf-wagner.de";

    github = "mrVanDalo";
    githubId = 839693;
  };
  mschristiansen = {
    name = "Mikkel Christiansen";
    email = "mikkel@rheosystems.com";

    github = "mschristiansen";
    githubId = 437005;
  };
  mschuwalow = {
    name = "Maxim Schuwalow";
    email = "maxim.schuwalow@gmail.com";

    github = "mschuwalow";
    githubId = 16665913;
  };
  msfjarvis = {
    name = "Harsh Shandilya";
    email = "nixos@msfjarvis.dev";

    github = "msfjarvis";
    githubId = 13348378;
    keys = [{
      fingerprint = "8F87 050B 0F9C B841 1515  7399 B784 3F82 3355 E9B9";
    }];
  };
  msiedlarek = {
    name = "Mikołaj Siedlarek";
    email = "mikolaj@siedlarek.pl";

    github = "msiedlarek";
    githubId = 133448;
  };
  msm = {
    name = "Jarosław Jedynak";
    email = "msm@tailcall.net";

    github = "msm-code";
    githubId = 7026881;
  };
  mstarzyk = {
    name = "Maciek Starzyk";
    email = "mstarzyk@gmail.com";

    github = "mstarzyk";
    githubId = 111304;
  };
  msteen = {
    name = "Matthijs Steen";
    email = "emailmatthijs@gmail.com";

    github = "msteen";
    githubId = 788953;
  };
  mstrangfeld = {
    name = "Marvin Strangfeld";
    email = "marvin@strangfeld.io";

    github = "mstrangfeld";
    githubId = 36842980;
  };
  mt-caret = {
    name = "Masayuki Takeda";
    email = "mtakeda.enigsol@gmail.com";

    github = "mt-caret";
    githubId = 4996739;
  };
  mtesseract = {
    name = "Moritz Clasmeier";
    email = "moritz@stackrox.com";

    github = "mtesseract";
    githubId = 11706080;
  };
  mtoohey = {
    name = "Matthew Toohey";
    email = "contact@mtoohey.com";

    github = "mtoohey31";
    githubId = 36740602;
  };
  MtP = {
    name = "Marko Poikonen";
    email = "marko.nixos@poikonen.de";

    github = "MtP76";
    githubId = 2176611;
  };
  mtreca = {
    name = "Maxime Tréca";
    email = "maxime.treca@gmail.com";

    github = "mtreca";
    githubId = 16440823;
  };
  mtreskin = {
    name = "Max Treskin";
    email = "zerthurd@gmail.com";

    github = "Zert";
    githubId = 39034;
  };
  mtrsk = {
    name = "Marcos Benevides";
    email = "marcos.schonfinkel@protonmail.com";

    github = "mtrsk";
    githubId = 16356569;
  };
  mudri = {
    name = "James Wood";
    email = "lamudri@gmail.com";

    github = "laMudri";
    githubId = 5139265;
  };
  mudrii = {
    name = "Ion Mudreac";
    email = "mudreac@gmail.com";

    github = "mudrii";
    githubId = 220262;
  };
  multun = {
    name = "Victor Collod";
    email = "victor.collod@epita.fr";

    github = "multun";
    githubId = 5047140;
  };
  munksgaard = {
    name = "Philip Munksgaard";
    email = "philip@munksgaard.me";

    matrix = "@philip:matrix.munksgaard.me";
    github = "munksgaard";
    githubId = 230613;
    keys = [{
      fingerprint = "5658 4D09 71AF E45F CC29 6BD7 4CE6 2A90 EFC0 B9B2";
    }];
  };
  mupdt = {
    name = "Matej Urbas";
    email = "nix@pdtpartners.com";

    github = "mupdt";
    githubId = 25388474;
  };
  muscaln = {
    name = "Mustafa Çalışkan";
    email = "muscaln@protonmail.com";

    github = "muscaln";
    githubId = 96225281;
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
    name = "Matt Votava";
    email = "mvnetbiz@gmail.com";

    matrix = "@mvtva:matrix.org";
    github = "mvnetbiz";
    githubId = 6455574;
  };
  mvs = {
    name = "Mikael Voss";
    email = "mvs@nya.yt";

    github = "illdefined";
    githubId = 772914;
  };
  mwolfe = {
    name = "Morgan Wolfe";
    email = "corp@m0rg.dev";

    github = "m0rg-dev";
    githubId = 38578268;
  };
  myaats = {
    name = "Mats";
    email = "mats@mats.sh";

    github = "Myaats";
    githubId = 6295090;
  };
  myrl = {
    name = "Myrl Hex";
    email = "myrl.0xf@gmail.com";

    github = "Myrl";
    githubId = 9636071;
  };
  n0emis = {
    name = "Ember Keske";
    email = "nixpkgs@n0emis.network";

    github = "n0emis";
    githubId = 22817873;
  };
  nadrieril = {
    name = "Nadrieril Feneanar";
    email = "nadrieril@gmail.com";

    github = "Nadrieril";
    githubId = 6783654;
  };
  nagisa = {
    name = "Simonas Kazlauskas";
    email = "nixpkgs@kazlauskas.me";

    github = "nagisa";
    githubId = 679122;
  };
  nagy = {
    name = "Daniel Nagy";
    email = "danielnagy@posteo.de";

    github = "nagy";
    githubId = 692274;
    keys = [{
      fingerprint = "F6AE 2C60 9196 A1BC ECD8  7108 1B8E 8DCB 576F B671";
    }];
  };
  nalbyuites = {
    name = "Ashijit Pramanik";
    email = "ashijit007@gmail.com";

    github = "nalbyuites";
    githubId = 1009523;
  };
  namore = {
    name = "Roman Naumann";
    email = "namor@hemio.de";

    github = "namore";
    githubId = 1222539;
  };
  naphta = {
    name = "Jake Hill";
    email = "naphta@noreply.github.com";

    github = "naphta";
    githubId = 6709831;
  };
  nasirhm = {
    name = "Nasir Hussain";
    email = "nasirhussainm14@gmail.com";

    github = "nasirhm";
    githubId = 35005234;
    keys = [{
      fingerprint = "7A10 AB8E 0BEC 566B 090C  9BE3 D812 6E55 9CE7 C35D";
    }];
  };
  nathan-gs = {
    name = "Nathan Bijnens";
    email = "nathan@nathan.gs";

    github = "nathan-gs";
    githubId = 330943;
  };
  nathanruiz = {
    name = "Nathan Ruiz";
    email = "nathanruiz@protonmail.com";

    github = "nathanruiz";
    githubId = 18604892;
  };
  nathyong = {
    name = "Nathan Yong";
    email = "nathyong@noreply.github.com";

    github = "nathyong";
    githubId = 818502;
  };
  natsukium = {
    name = "Tomoya Otabi";
    email = "nixpkgs@natsukium.com";

    github = "natsukium";
    githubId = 25083790;
    keys = [{
      fingerprint = "3D14 6004 004C F882 D519  6CD4 9EA4 5A31 DB99 4C53";
    }];
  };
  natto1784 = {
    name = "Amneesh Singh";
    email = "natto@weirdnatto.in";

    github = "natto1784";
    githubId = 56316606;
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
    name = "Nick Braga";
    email = "nbr@users.noreply.github.com";

    github = "nbr";
    githubId = 3819225;
  };
  nbren12 = {
    name = "Noah Brenowitz";
    email = "nbren12@gmail.com";

    github = "nbren12";
    githubId = 1386642;
  };
  ncfavier = {
    name = "Naïm Favier";
    email = "n@monade.li";

    matrix = "@ncfavier:matrix.org";
    github = "ncfavier";
    githubId = 4323933;
    keys = [{
      fingerprint = "F3EB 4BBB 4E71 99BC 299C  D4E9 95AF CE82 1190 8325";
    }];
  };
  nckx = {
    name = "Tobias Geerinckx-Rice";
    email = "github@tobias.gr";

    github = "nckx";
    githubId = 364510;
  };
  ndl = {
    name = "Alexander Tsvyashchenko";
    email = "ndl@endl.ch";

    github = "ndl";
    githubId = 137805;
  };
  Necior = {
    name = "Adrian Sadłocha";
    email = "adrian@sadlocha.eu";

    matrix = "@n3t:matrix.org";
    github = "Necior";
    githubId = 2404518;
  };
  necrophcodr = {
    name = "Steffen Rytter Postas";
    email = "nc@scalehost.eu";

    github = "necrophcodr";
    githubId = 575887;
  };
  neeasade = {
    name = "Nathan Isom";
    email = "nathanisom27@gmail.com";

    github = "neeasade";
    githubId = 3747396;
  };
  neilmayhew = {
    name = "Neil Mayhew";
    email = "nix@neil.mayhew.name";

    github = "neilmayhew";
    githubId = 166791;
  };
  nek0 = {
    name = "Amedeo Molnár";
    email = "nek0@nek0.eu";

    github = "nek0";
    githubId = 1859691;
  };
  nelsonjeppesen = {
    name = "Nelson Jeppesen";
    email = "nix@jeppesen.io";

    github = "NelsonJeppesen";
    githubId = 50854675;
  };
  neonfuz = {
    name = "Sage Raflik";
    email = "neonfuz@gmail.com";

    github = "neonfuz";
    githubId = 2590830;
  };
  neosimsim = {
    name = "Alexander Ben Nasrallah";
    email = "me@abn.sh";

    github = "neosimsim";
    githubId = 1771772;
  };
  nequissimus = {
    name = "Tim Steinbach";
    email = "tim@nequissimus.com";

    github = "NeQuissimus";
    githubId = 628342;
  };
  nerdypepper = {
    name = "Akshay Oppiliappan";
    email = "nerdy@peppe.rs";

    github = "nerdypepper";
    githubId = 23743547;
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
    name = "Sébastien Iooss";
    email = "archimist.linux@gmail.com";

    github = "Net-Mist";
    githubId = 13920346;
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
    name = "Jason Wing";
    email = "jason.wing@gmx.de";

    github = "netcrns";
    githubId = 34162313;
  };
  netixx = {
    name = "François Espinet";
    email = "dev.espinetfrancois@gmail.com";

    github = "netixx";
    githubId = 1488603;
  };
  neverbehave = {
    name = "Xinhao Luo";
    email = "i@never.pet";

    github = "NeverBehave";
    githubId = 17120571;
  };
  newam = {
    name = "Alex Martens";
    email = "alex@thinglab.org";

    github = "newAM";
    githubId = 7845120;
  };
  ngerstle = {
    name = "Nicholas Gerstle";
    email = "ngerstle@gmail.com";

    github = "ngerstle";
    githubId = 1023752;
  };
  ngiger = {
    name = "Niklaus Giger";
    email = "niklaus.giger@member.fsf.org";

    github = "ngiger";
    githubId = 265800;
  };
  nh2 = {
    name = "Niklas Hambüchen";
    email = "mail@nh2.me";

    matrix = "@nh2:matrix.org";
    github = "nh2";
    githubId = 399535;
  };
  nhooyr = {
    name = "Anmol Sethi";
    email = "anmol@aubble.com";

    github = "nhooyr";
    githubId = 10180857;
  };
  nialov = {
    name = "Nikolas Ovaskainen";
    email = "nikolasovaskainen@gmail.com";

    github = "nialov";
    githubId = 47318483;
  };
  nicbk = {
    name = "Nicolás Kennedy";
    email = "nicolas@nicbk.com";

    github = "nicbk";
    githubId = 77309427;
    keys = [{
      fingerprint = "7BC1 77D9 C222 B1DC FB2F  0484 C061 089E FEBF 7A35";
    }];
  };
  nichtsfrei = {
    name = "Philipp Eder";
    email = "philipp.eder@posteo.net";

    github = "nichtsfrei";
    githubId = 1665818;
  };
  nickcao = {
    name = "Nick Cao";
    email = "nickcao@nichi.co";

    github = "NickCao";
    githubId = 15247171;
  };
  nickhu = {
    name = "Nick Hu";
    email = "me@nickhu.co.uk";

    github = "NickHu";
    githubId = 450276;
  };
  nicknovitski = {
    name = "Nick Novitski";
    email = "nixpkgs@nicknovitski.com";

    github = "nicknovitski";
    githubId = 151337;
  };
  nico202 = {
    name = "Nicolò Balzarotti";
    email = "anothersms@gmail.com";

    github = "nico202";
    githubId = 8214542;
  };
  nidabdella = {
    name = "Mohamed Nidabdella";
    email = "nidabdella.mohamed@gmail.com";

    github = "nidabdella";
    githubId = 8083813;
  };
  NieDzejkob = {
    name = "Jakub Kądziołka";
    email = "kuba@kadziolka.net";

    github = "meithecatte";
    githubId = 23580910;
    keys = [{
      fingerprint = "E576 BFB2 CF6E B13D F571  33B9 E315 A758 4613 1564";
    }];
  };
  nigelgbanks = {
    name = "Nigel Banks";
    email = "nigel.g.banks@gmail.com";

    github = "nigelgbanks";
    githubId = 487373;
  };
  nikitavoloboev = {
    name = "Nikita Voloboev";
    email = "nikita.voloboev@gmail.com";

    github = "nikitavoloboev";
    githubId = 6391776;
  };
  NikolaMandic = {
    name = "Ratko Mladic";
    email = "nikola@mandic.email";

    github = "NikolaMandic";
    githubId = 4368690;
  };
  nikstur = {
    name = "nikstur";
    email = "nikstur@outlook.com";

    github = "nikstur";
    githubId = 61635709;
  };
  nilp0inter = {
    name = "Roberto Abdelkader Martínez Pérez";
    email = "robertomartinezp@gmail.com";

    github = "nilp0inter";
    githubId = 1224006;
  };
  nils-degroot = {
    name = "Nils de Groot";
    email = "nils@peeko.nl";

    github = "nils-degroot";
    githubId = 53556985;
  };
  nilsirl = {
    name = "Nils ANDRÉ-CHANG";
    email = "nils@nilsand.re";

    github = "NilsIrl";
    githubId = 26231126;
  };
  ninjatrappeur = {
    name = "Félix Baylac-Jacqué";
    email = "felix@alternativebit.fr";

    matrix = "@ninjatrappeur:matrix.org";
    github = "NinjaTrappeur";
    githubId = 1219785;
  };
  ninjin = {
    name = "Pontus Stenetorp";
    email = "pontus@stenetorp.se";

    github = "ninjin";
    githubId = 354934;
    keys = [{
      fingerprint = "0966 2F9F 3FDA C22B C22E  4CE1 D430 2875 00E6 483C";
    }];
  };
  nioncode = {
    name = "Nicolas Schneider";
    email = "nioncode+github@gmail.com";

    github = "nioncode";
    githubId = 3159451;
  };
  nitsky = {
    name = "nitsky";
    email = "492793+nitsky@users.noreply.github.com";

    github = "nitsky";
    githubId = 492793;
  };
  nixbitcoin = {
    name = "nixbitcoindev";
    email = "nixbitcoin@i2pmail.org";

    github = "nixbitcoin";
    githubId = 45737139;
    keys = [{
      fingerprint = "577A 3452 7F3E 2A85 E80F  E164 DD11 F9AD 5308 B3BA";
    }];
  };
  nixinator = {
    name = "Rick Sanchez";
    email = "33lockdown33@protonmail.com";

    matrix = "@nixinator:nixos.dev";
    github = "nixinator";
    githubId = 66913205;
  };
  nixy = {
    name = "Andrew R. M.";
    email = "nixy@nixy.moe";

    github = "nixy";
    githubId = 7588406;
  };
  nkalupahana = {
    name = "Nisala Kalupahana";
    email = "hello@nisa.la";

    github = "nkalupahana";
    githubId = 7347290;
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
  nkpvk = {
    name = "Niko Pavlinek";
    email = "niko.pavlinek@gmail.com";

    github = "npavlinek";
    githubId = 16385648;
  };
  nloomans = {
    name = "Noah Loomans";
    email = "noah@nixos.noahloomans.com";

    github = "nloomans";
    githubId = 7829481;
  };
  nmattia = {
    name = "Nicolas Mattia";
    email = "nicolas@nmattia.com";

    github = "nmattia";
    githubId = 6930756;
  };
  nobbz = {
    name = "Norbert Melzer";
    email = "timmelzer+nixpkgs@gmail.com";

    github = "NobbZ";
    githubId = 58951;
  };
  nocoolnametom = {
    name = "Tom Doggett";
    email = "nocoolnametom@gmail.com";

    github = "nocoolnametom";
    githubId = 810877;
  };
  noisersup = {
    name = "Patryk Kwiatek";
    email = "patryk@kwiatek.xyz";

    github = "noisersup";
    githubId = 42322511;
  };
  nomeata = {
    name = "Joachim Breitner";
    email = "mail@joachim-breitner.de";

    github = "nomeata";
    githubId = 148037;
  };
  nomisiv = {
    name = "Simon Gutgesell";
    email = "simon@nomisiv.com";

    github = "NomisIV";
    githubId = 47303199;
  };
  noneucat = {
    name = "Andy Chun";
    email = "andy@lolc.at";

    matrix = "@noneucat:lolc.at";
    github = "noneucat";
    githubId = 40049608;
  };
  nook = {
    name = "Tom Nook";
    email = "0xnook@protonmail.com";

    github = "0xnook";
    githubId = 88323754;
  };
  noreferences = {
    name = "Juozas Norkus";
    email = "norkus@norkus.net";

    github = "jozuas";
    githubId = 13085275;
  };
  norfair = {
    name = "Tom Sydney Kerckhove";
    email = "syd@cs-syd.eu";

    github = "NorfairKing";
    githubId = 3521180;
  };
  not-my-segfault = {
    name = "Michal S.";
    email = "michal@tar.black";

    matrix = "@michal:tar.black";
    github = "not-my-segfault";
    githubId = 30374463;
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
  notthemessiah = {
    name = "Brian Cohen";
    email = "brian.cohen.88@gmail.com";

    github = "NOTtheMessiah";
    githubId = 2946283;
  };
  novoxd = {
    name = "Kirill Struokov";
    email = "radnovox@gmail.com";

    github = "novoxd";
    githubId = 6052922;
  };
  np = {
    name = "Nicolas Pouillard";
    email = "np.nix@nicolaspouillard.fr";

    github = "np";
    githubId = 5548;
  };
  npatsakula = {
    name = "Patsakula Nikita";
    email = "nikita.patsakula@gmail.com";

    github = "npatsakula";
    githubId = 23001619;
  };
  nphilou = {
    name = "Philippe Nguyen";
    email = "nphilou@gmail.com";

    github = "nphilou";
    githubId = 9939720;
  };
  nrdxp = {
    name = "Tim DeHerrera";
    email = "tim.deh@pm.me";

    matrix = "@timdeh:matrix.org";
    github = "nrdxp";
    githubId = 34083928;
  };
  nshalman = {
    name = "Nahum Shalman";
    email = "nahamu@gmail.com";

    github = "nshalman";
    githubId = 20391;
  };
  nsnelson = {
    name = "Noah Snelson";
    email = "noah.snelson@protonmail.com";

    github = "peeley";
    githubId = 30942198;
  };
  nthorne = {
    name = "Niklas Thörne";
    email = "notrupertthorne@gmail.com";

    github = "nthorne";
    githubId = 1839979;
  };
  nukaduka = {
    name = "Kartik Gokte";
    email = "ksgokte@gmail.com";

    github = "NukaDuka";
    githubId = 22592293;
  };
  nullishamy = {
    name = "nullishamy";
    email = "amy.codes@null.net";

    github = "nullishamy";
    githubId = 99221043;
  };
  nullx76 = {
    name = "Victor Roest";
    email = "nix@xirion.net";

    github = "NULLx76";
    githubId = 1809198;
  };
  numinit = {
    name = "Morgan Jones";
    email = "me@numin.it";

    github = "numinit";
    githubId = 369111;
  };
  numkem = {
    name = "Sebastien Bariteau";
    email = "numkem@numkem.org";

    matrix = "@numkem:matrix.org";
    github = "numkem";
    githubId = 332423;
  };
  nviets = {
    name = "Nathan Viets";
    email = "nathan.g.viets@gmail.com";

    github = "nviets";
    githubId = 16027994;
  };
  nyanloutre = {
    name = "Paul Trehiou";
    email = "paul@nyanlout.re";

    github = "nyanloutre";
    githubId = 7677321;
  };
  nyanotech = {
    name = "nyanotech";
    email = "nyanotechnology@gmail.com";

    github = "nyanotech";
    githubId = 33802077;
  };
  nyarly = {
    name = "Judson Lester";
    email = "nyarly@gmail.com";

    github = "nyarly";
    githubId = 127548;
  };
  nzbr = {
    name = "nzbr";
    email = "nixos@nzbr.de";

    matrix = "@nzbr:nzbr.de";
    github = "nzbr";
    githubId = 7851175;
    keys = [{
      fingerprint = "BF3A 3EE6 3144 2C5F C9FB  39A7 6C78 B50B 97A4 2F8A";
    }];
  };
  nzhang-zh = {
    name = "Ning Zhang";
    email = "n.zhang.hp.au@gmail.com";

    github = "nzhang-zh";
    githubId = 30825096;
  };
  obadz = {
    name = "obadz";
    email = "obadz-nixos@obadz.com";

    github = "obadz";
    githubId = 3359345;
  };
  oberblastmeister = {
    name = "Brian Shu";
    email = "littlebubu.shu@gmail.com";

    github = "oberblastmeister";
    githubId = 61095988;
  };
  obfusk = {
    name = "FC Stegerman";
    email = "flx@obfusk.net";

    matrix = "@obfusk:matrix.org";
    github = "obfusk";
    githubId = 1260687;
    keys = [{
      fingerprint = "D5E4 A51D F8D2 55B9 FAC6  A9BB 2F96 07F0 9B36 0F2D";
    }];
  };
  obsidian-systems-maintenance = {
    name = "Obsidian Systems Maintenance";
    email = "maintainer@obsidian.systems";

    github = "obsidian-systems-maintenance";
    githubId = 80847921;
  };
  ocfox = {
    name = "ocfox";
    email = "i@ocfox.me";

    github = "ocfox";
    githubId = 47410251;
    keys = [{
      fingerprint = "939E F8A5 CED8 7F50 5BB5  B2D0 24BC 2738 5F70 234F";
    }];
  };
  odi = {
    name = "Oliver Dunkl";
    email = "oliver.dunkl@gmail.com";

    github = "odi";
    githubId = 158758;
  };
  ofek = {
    name = "Ofek Lev";
    email = "oss@ofek.dev";

    github = "ofek";
    githubId = 9677399;
  };
  offline = {
    name = "Jaka Hudoklin";
    email = "jaka@x-truder.net";

    github = "offlinehacker";
    githubId = 585547;
  };
  oida = {
    name = "oida";
    email = "oida@posteo.de";

    github = "oida";
    githubId = 7249506;
  };
  olcai = {
    name = "Erik Timan";
    email = "dev@timan.info";

    github = "olcai";
    githubId = 20923;
  };
  olebedev = {
    name = "Oleg Lebedev";
    email = "ole6edev@gmail.com";

    github = "olebedev";
    githubId = 848535;
  };
  olejorgenb = {
    name = "Ole Jørgen Brønner";
    email = "olejorgenb@yahoo.no";

    github = "olejorgenb";
    githubId = 72201;
  };
  ollieB = {
    name = "Ollie Bunting";
    email = "1237862+oliverbunting@users.noreply.github.com";

    github = "oliverbunting";
    githubId = 1237862;
  };
  oluceps = {
    name = "oluceps";
    email = "nixos@oluceps.uk";

    github = "oluceps";
    githubId = 35628088;
  };
  olynch = {
    name = "Owen Lynch";
    email = "owen@olynch.me";

    github = "olynch";
    githubId = 4728903;
  };
  omasanori = {
    name = "Masanori Ogino";
    email = "167209+omasanori@users.noreply.github.com";

    github = "omasanori";
    githubId = 167209;
  };
  omgbebebe = {
    name = "Sergey Bubnov";
    email = "omgbebebe@gmail.com";

    github = "omgbebebe";
    githubId = 588167;
  };
  omnipotententity = {
    name = "Michael Reilly";
    email = "omnipotententity@gmail.com";

    github = "OmnipotentEntity";
    githubId = 1538622;
  };
  onixie = {
    name = "Yc. Shen";
    email = "onixie@gmail.com";

    github = "onixie";
    githubId = 817073;
  };
  onny = {
    name = "Jonas Heinrich";
    email = "onny@project-insanity.org";

    github = "onny";
    githubId = 757752;
  };
  onsails = {
    name = "Andrey Kuznetsov";
    email = "andrey@onsails.com";

    github = "onsails";
    githubId = 107261;
  };
  onthestairs = {
    name = "Austin Platt";
    email = "austinplatt@gmail.com";

    github = "onthestairs";
    githubId = 915970;
  };
  ony = {
    name = "Mykola Orliuk";
    email = "virkony@gmail.com";

    github = "ony";
    githubId = 11265;
  };
  opeik = {
    name = "Sandro Stikić";
    email = "sandro@stikic.com";

    github = "opeik";
    githubId = 11566773;
  };
  OPNA2608 = {
    name = "Christoph Neidahl";
    email = "christoph.neidahl@gmail.com";

    github = "OPNA2608";
    githubId = 23431373;
  };
  orbekk = {
    name = "KJ Ørbekk";
    email = "kjetil.orbekk@gmail.com";

    github = "orbekk";
    githubId = 19862;
  };
  orbitz = {
    name = "Malcolm Matalka";
    email = "mmatalka@gmail.com";

    github = "orbitz";
    githubId = 75299;
  };
  orivej = {
    name = "Orivej Desh";
    email = "orivej@gmx.fr";

    github = "orivej";
    githubId = 101514;
  };
  ornxka = {
    name = "ornxka";
    email = "ornxka@littledevil.sh";

    github = "ornxka";
    githubId = 52086525;
  };
  oro = {
    name = "Marco Orovecchia";
    email = "marco@orovecchia.at";

    github = "Oro";
    githubId = 357005;
  };
  osener = {
    name = "Ozan Sener";
    email = "ozan@ozansener.com";

    github = "osener";
    githubId = 111265;
  };
  otavio = {
    name = "Otavio Salvador";
    email = "otavio.salvador@ossystems.com.br";

    github = "otavio";
    githubId = 25278;
  };
  otini = {
    name = "Olivier Nicole";
    email = "olivier@chnik.fr";

    github = "OlivierNicole";
    githubId = 14031333;
  };
  otwieracz = {
    name = "Slawomir Gonet";
    email = "slawek@otwiera.cz";

    github = "otwieracz";
    githubId = 108072;
  };
  oxalica = {
    name = "oxalica";
    email = "oxalicc@pm.me";

    github = "oxalica";
    githubId = 14816024;
    keys = [{
      fingerprint = "F90F FD6D 585C 2BA1 F13D  E8A9 7571 654C F88E 31C2";
    }];
  };
  oxapentane = {
    name = "Grigory Shipunov";
    email = "blame@oxapentane.com";

    github = "oxapentane";
    githubId = 1297357;
    keys = [{
      fingerprint = "DD09 98E6 CDF2 9453 7FC6  04F9 91FA 5E5B F9AA 901C";
    }];
  };
  oxij = {
    name = "Jan Malakhovski";
    email = "oxij@oxij.org";

    github = "oxij";
    githubId = 391919;
    keys = [{
      fingerprint = "514B B966 B46E 3565 0508  86E8 0E6C A66E 5C55 7AA8";
    }];
  };
  oxzi = {
    name = "Alvar Penning";
    email = "post@0x21.biz";

    github = "oxzi";
    githubId = 8402811;
    keys = [{
      fingerprint = "EB14 4E67 E57D 27E2 B5A4  CD8C F32A 4563 7FA2 5E31";
    }];
  };
  oyren = {
    name = "Moritz Scheuren";
    email = "m.scheuren@oyra.eu";

    github = "oyren";
    githubId = 15930073;
  };
  ozkutuk = {
    name = "Berk Özkütük";
    email = "ozkutuk@protonmail.com";

    github = "ozkutuk";
    githubId = 5948762;
  };
  p-h = {
    name = "Philippe Hürlimann";
    email = "p@hurlimann.org";

    github = "p-h";
    githubId = 645664;
  };
  p3psi = {
    name = "Elliot Boo";
    email = "p3psi.boo@gmail.com";

    github = "p3psi-boo";
    githubId = 43925055;
  };
  pablovsky = {
    name = "Pablo Andres Dealbera";
    email = "dealberapablo07@gmail.com";

    github = "Pablo1107";
    githubId = 17091659;
  };
  pacien = {
    name = "Pacien Tran-Girard";
    email = "b4gx3q.nixpkgs@pacien.net";

    github = "pacien";
    githubId = 1449319;
  };
  pacman99 = {
    name = "Parthiv Seetharaman";
    email = "pachum99@gmail.com";

    matrix = "@pachumicchu:myrdd.info";
    github = "Pacman99";
    githubId = 16345849;
  };
  paddygord = {
    name = "Patrick Gordon";
    email = "pgpatrickgordon@gmail.com";

    github = "paddygord";
    githubId = 10776658;
  };
  paholg = {
    name = "Paho Lurie-Gregg";
    email = "paho@paholg.com";

    github = "paholg";
    githubId = 4908217;
  };
  pakhfn = {
    name = "Fedor Pakhomov";
    email = "pakhfn@gmail.com";

    github = "pakhfn";
    githubId = 11016164;
  };
  paluh = {
    name = "Tomasz Rybarczyk";
    email = "paluho@gmail.com";

    github = "paluh";
    githubId = 190249;
  };
  pamplemousse = {
    name = "Xavier Maso";
    email = "xav.maso@gmail.com";

    matrix = "@pamplemouss_:matrix.org";
    github = "Pamplemousse";
    githubId = 2647236;
  };
  panaeon = {
    name = "Vitalii Voloshyn";
    email = "vitalii.voloshyn@gmail.com";

    github = "PanAeon";
    githubId = 686076;
  };
  pandaman = {
    name = "pandaman";
    email = "kointosudesuyo@infoseek.jp";

    github = "pandaman64";
    githubId = 1788628;
  };
  panicgh = {
    name = "Nicolas Benes";
    email = "nbenes.gh@xandea.de";

    github = "panicgh";
    githubId = 79252025;
  };
  paperdigits = {
    name = "Mica Semrick";
    email = "mica@silentumbrella.com";

    github = "paperdigits";
    githubId = 71795;
  };
  paraseba = {
    name = "Sebastian Galkin";
    email = "paraseba@gmail.com";

    github = "paraseba";
    githubId = 20792;
  };
  parasrah = {
    name = "Brad Pfannmuller";
    email = "nixos@parasrah.com";

    github = "Parasrah";
    githubId = 14935550;
  };
  parras = {
    name = "Philipp Arras";
    email = "c@philipp-arras.de";

    github = "phiadaarr";
    githubId = 33826198;
  };
  pashashocky = {
    name = "Pash Shocky";
    email = "pashashocky@gmail.com";

    github = "pashashocky";
    githubId = 673857;
  };
  pashev = {
    name = "Igor Pashev";
    email = "pashev.igor@gmail.com";

    github = "ip1981";
    githubId = 131844;
  };
  pasqui23 = {
    name = "pasqui23";
    email = "p3dimaria@hotmail.it";

    github = "pasqui23";
    githubId = 6931743;
  };
  patricksjackson = {
    name = "Patrick Jackson";
    email = "patrick@jackson.dev";

    github = "patricksjackson";
    githubId = 160646;
  };
  patryk27 = {
    name = "Patryk Wychowaniec";
    email = "pwychowaniec@pm.me";

    github = "Patryk27";
    githubId = 3395477;
    keys = [{
      fingerprint = "196A BFEC 6A1D D1EC 7594  F8D1 F625 47D0 75E0 9767";
    }];
  };
  patryk4815 = {
    name = "Patryk Sondej";
    email = "patryk.sondej@gmail.com";

    github = "patryk4815";
    githubId = 3074260;
  };
  patternspandemic = {
    name = "Brad Christensen";
    email = "patternspandemic@live.com";

    github = "patternspandemic";
    githubId = 15645854;
  };
  pawelpacana = {
    name = "Paweł Pacana";
    email = "pawel.pacana@gmail.com";

    github = "pawelpacana";
    githubId = 116740;
  };
  payas = {
    name = "Payas Relekar";
    email = "relekarpayas@gmail.com";

    github = "bhankas";
    githubId = 24254289;
  };
  pb- = {
    name = "Paul Baecher";
    email = "pbaecher@gmail.com";

    github = "pb-";
    githubId = 84886;
  };
  pbar = {
    name = "Pierce Bartine";
    email = "piercebartine@gmail.com";

    github = "pbar1";
    githubId = 26949935;
  };
  pblkt = {
    name = "pebble kite";
    email = "pebblekite@gmail.com";

    github = "pblkt";
    githubId = 6498458;
  };
  pbogdan = {
    name = "Piotr Bogdan";
    email = "ppbogdan@gmail.com";

    github = "pbogdan";
    githubId = 157610;
  };
  pborzenkov = {
    name = "Pavel Borzenkov";
    email = "pavel@borzenkov.net";

    github = "pborzenkov";
    githubId = 434254;
  };
  pbsds = {
    name = "Peder Bergebakken Sundt";
    email = "pbsds@hotmail.com";

    github = "pbsds";
    githubId = 140964;
  };
  pcarrier = {
    name = "Pierre Carrier";
    email = "pc@rrier.ca";

    github = "pcarrier";
    githubId = 8641;
  };
  pedrohlc = {
    name = "Pedro Lara Campos";
    email = "root@pedrohlc.com";

    github = "PedroHLC";
    githubId = 1368952;
  };
  peelz = {
    name = "peelz";
    email = "peelz.dev+nixpkgs@gmail.com";

    github = "notpeelz";
    githubId = 920910;
  };
  penguwin = {
    name = "Nicolas Martin";
    email = "penguwin@penguwin.eu";

    github = "penguwin";
    githubId = 13225611;
  };
  pennae = {
    name = "pennae";
    email = "github@quasiparticle.net";

    github = "pennae";
    githubId = 82953136;
  };
  periklis = {
    name = "Periklis Tsirakidis";
    email = "theopompos@gmail.com";

    github = "periklis";
    githubId = 152312;
  };
  petercommand = {
    name = "petercommand";
    email = "petercommand@gmail.com";

    github = "petercommand";
    githubId = 1260660;
  };
  peterhoeg = {
    name = "Peter Hoeg";
    email = "peter@hoeg.com";

    matrix = "@peter:hoeg.com";
    github = "peterhoeg";
    githubId = 722550;
  };
  peterromfeldhk = {
    name = "Peter Romfeld";
    email = "peter.romfeld.hk@gmail.com";

    github = "peterromfeldhk";
    githubId = 5515707;
  };
  petersjt014 = {
    name = "Josh Peters";
    email = "petersjt014@gmail.com";

    github = "petersjt014";
    githubId = 29493551;
  };
  peterwilli = {
    name = "Peter Willemsen";
    email = "peter@codebuffet.co";

    github = "peterwilli";
    githubId = 1212814;
    keys = [{
      fingerprint = "A37F D403 88E2 D026 B9F6  9617 5C9D D4BF B96A 28F0";
    }];
  };
  peti = {
    name = "Peter Simons";
    email = "simons@cryp.to";

    github = "peti";
    githubId = 28323;
  };
  petrosagg = {
    name = "Petros Angelatos";
    email = "petrosagg@gmail.com";

    github = "petrosagg";
    githubId = 939420;
  };
  petterstorvik = {
    name = "Petter Storvik";
    email = "petterstorvik@gmail.com";

    github = "storvik";
    githubId = 3438604;
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
    name = "Philip Potter";
    email = "philip.g.potter@gmail.com";

    github = "philandstuff";
    githubId = 581269;
  };
  phile314 = {
    name = "Philipp Hausmann";
    email = "nix@314.ch";

    github = "phile314";
    githubId = 1640697;
  };
  Philipp-M = {
    name = "Philipp Mildenberger";
    email = "philipp@mildenberger.me";

    github = "Philipp-M";
    githubId = 9267430;
  };
  Phlogistique = {
    name = "Noé Rubinstein";
    email = "noe.rubinstein@gmail.com";

    github = "Phlogistique";
    githubId = 421510;
  };
  photex = {
    name = "Chip Collier";
    email = "photex@gmail.com";

    github = "photex";
    githubId = 301903;
  };
  phryneas = {
    name = "Lenz Weber";
    email = "mail@lenzw.de";

    github = "phryneas";
    githubId = 4282439;
  };
  phunehehe = {
    name = "Hoang Xuan Phu";
    email = "phunehehe@gmail.com";

    github = "phunehehe";
    githubId = 627831;
  };
  piegames = {
    name = "piegames";
    email = "nix@piegames.de";

    matrix = "@piegames:matrix.org";
    github = "piegamesde";
    githubId = 14054505;
  };
  pierrechevalier83 = {
    name = "Pierre Chevalier";
    email = "pierrechevalier83@gmail.com";

    github = "pierrechevalier83";
    githubId = 5790907;
  };
  pierreis = {
    name = "Pierre Matri";
    email = "pierre@pierre.is";

    github = "pierreis";
    githubId = 203973;
  };
  pierrer = {
    name = "Pierre Radermecker";
    email = "pierrer@pi3r.be";

    github = "PierreR";
    githubId = 93115;
  };
  pierron = {
    name = "Nicolas B. Pierron";
    email = "nixos@nbp.name";

    github = "nbp";
    githubId = 1179566;
  };
  pimeys = {
    name = "Julius de Bruijn";
    email = "julius@nauk.io";

    github = "pimeys";
    githubId = 34967;
  };
  pingiun = {
    name = "Jelle Besseling";
    email = "nixos@pingiun.com";

    github = "pingiun";
    githubId = 1576660;
    keys = [{
      fingerprint = "A3A3 65AE 16ED A7A0 C29C  88F1 9712 452E 8BE3 372E";
    }];
  };
  pinpox = {
    name = "Pablo Ovelleiro Corral";
    email = "mail@pablo.tools";

    github = "pinpox";
    githubId = 1719781;
    keys = [{
      fingerprint = "D03B 218C AE77 1F77 D7F9  20D9 823A 6154 4264 08D3";
    }];
  };
  piperswe = {
    name = "Piper McCorkle";
    email = "contact@piperswe.me";

    github = "piperswe";
    githubId = 1830959;
  };
  pjbarnoy = {
    name = "Perry Barnoy";
    email = "pjbarnoy@gmail.com";

    github = "pjbarnoy";
    githubId = 119460;
  };
  pjjw = {
    name = "Peter Woodman";
    email = "peter@shortbus.org";

    github = "pjjw";
    githubId = 638;
  };
  pjones = {
    name = "Peter Jones";
    email = "pjones@devalot.com";

    github = "pjones";
    githubId = 3737;
  };
  pkharvey = {
    name = "Paul Harvey";
    email = "kayharvey@protonmail.com";

    github = "pkharvey";
    githubId = 50750875;
  };
  pkmx = {
    name = "Chih-Mao Chen";
    email = "pkmx.tw@gmail.com";

    github = "PkmX";
    githubId = 610615;
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
    name = "Jonas Beyer";
    email = "mail@oddco.de";

    github = "plchldr";
    githubId = 11639001;
  };
  plcplc = {
    name = "Philip Lykke Carlsen";
    email = "plcplc@gmail.com";

    github = "plcplc";
    githubId = 358550;
  };
  pleshevskiy = {
    name = "Dmitriy Pleshevskiy";
    email = "dmitriy@pleshevski.ru";

    github = "pleshevskiy";
    githubId = 7839004;
  };
  plumps = {
    name = "Maksim Bronsky";
    email = "maks.bronsky@web.de";

    github = "plumps";
    githubId = 13000278;
  };
  PlushBeaver = {
    name = "Dmitry Kozlyuk";
    email = "dmitry.kozliuk+nixpkgs@gmail.com";

    github = "PlushBeaver";
    githubId = 8988269;
  };
  pmahoney = {
    name = "Patrick Mahoney";
    email = "pat@polycrystal.org";

    github = "pmahoney";
    githubId = 103822;
  };
  pmenke = {
    name = "Philipp Menke";
    email = "nixos@pmenke.de";

    github = "pmenke-de";
    githubId = 898922;
    keys = [{
      fingerprint = "ED54 5EFD 64B6 B5AA EC61 8C16 EB7F 2D4C CBE2 3B69";
    }];
  };
  pmeunier = {
    name = "Pierre-Étienne Meunier";
    email = "pierre-etienne.meunier@inria.fr";

    github = "P-E-Meunier";
    githubId = 17021304;
  };
  pmiddend = {
    name = "Philipp Middendorf";
    email = "pmidden@secure.mailbox.org";

    github = "pmiddend";
    githubId = 178496;
  };
  pmw = {
    name = "Philip White";
    email = "philip@mailworks.org";

    matrix = "@philip4g:matrix.org";
    github = "philipmw";
    githubId = 1379645;
    keys = [{
      fingerprint = "9AB0 6C94 C3D1 F9D0 B9D9  A832 BC54 6FB3 B16C 8B0B";
    }];
  };
  pmy = {
    name = "Peng Mei Yu";
    email = "pmy@xqzp.net";

    github = "pmeiyu";
    githubId = 8529551;
  };
  pmyjavec = {
    name = "Pauly Myjavec";
    email = "pauly@myjavec.com";

    github = "pmyjavec";
    githubId = 315096;
  };
  pnelson = {
    name = "Philip Nelson";
    email = "me@pnelson.ca";

    github = "pnelson";
    githubId = 579773;
  };
  pneumaticat = {
    name = "Kevin Liu";
    email = "kevin@potatofrom.space";

    github = "kliu128";
    githubId = 11365056;
  };
  pnmadelaine = {
    name = "Paul-Nicolas Madelaine";
    email = "pnm@pnm.tf";

    github = "pnmadelaine";
    githubId = 21977014;
  };
  pnotequalnp = {
    name = "Kevin Mullins";
    email = "kevin@pnotequalnp.com";

    github = "pnotequalnp";
    githubId = 46154511;
    keys = [{
      fingerprint = "2CD2 B030 BD22 32EF DF5A  008A 3618 20A4 5DB4 1E9A";
    }];
  };
  podocarp = {
    name = "Jia Xiaodong";
    email = "xdjiaxd@gmail.com";

    github = "podocarp";
    githubId = 10473184;
  };
  poelzi = {
    name = "Daniel Poelzleithner";
    email = "nix@poelzi.org";

    github = "poelzi";
    githubId = 66107;
  };
  pogobanane = {
    name = "Peter Okelmann";
    email = "mail@peter-okelmann.de";

    github = "pogobanane";
    githubId = 38314551;
  };
  polarmutex = {
    name = "Brian Ryall";
    email = "brian@brianryall.xyz";

    github = "polarmutex";
    githubId = 115141;
  };
  polendri = {
    name = "Paul Hendry";
    email = "paul@ijj.li";

    github = "polendri";
    githubId = 1829032;
  };
  polygon = {
    name = "Polygon";
    email = "polygon@wh2.tu-dresden.de";

    github = "polygon";
    githubId = 51489;
  };
  polykernel = {
    name = "polykernel";
    email = "81340136+polykernel@users.noreply.github.com";

    github = "polykernel";
    githubId = 81340136;
  };
  polyrod = {
    name = "Maurizio Di Pietro";
    email = "dc1mdp@gmail.com";

    github = "polyrod";
    githubId = 24878306;
  };
  pombeirp = {
    name = "Pedro Pombeiro";
    email = "nix@endgr.33mail.com";

    github = "pedropombeiro";
    githubId = 138074;
  };
  portothree = {
    name = "Gustavo Porto";
    email = "gus@p8s.co";

    github = "portothree";
    githubId = 3718120;
  };
  poscat = {
    name = "Poscat Tarski";
    email = "poscat@mail.poscat.moe";

    github = "poscat0x04";
    githubId = 53291983;
    keys = [{
      fingerprint = "48AD DE10 F27B AFB4 7BB0  CCAF 2D25 95A0 0D08 ACE0";
    }];
  };
  posch = {
    name = "Tobias Poschwatta";
    email = "tp@fonz.de";

    github = "posch";
    githubId = 146413;
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
    name = "Pradeep Chhetri";
    email = "pradeep.chhetri89@gmail.com";

    github = "pradeepchhetri";
    githubId = 2232667;
  };
  pradyuman = {
    name = "Pradyuman Vig";
    email = "me@pradyuman.co";

    github = "pradyuman";
    githubId = 9904569;
    keys = [{
      fingerprint = "240B 57DE 4271 2480 7CE3  EAC8 4F74 D536 1C4C A31E";
    }];
  };
  preisschild = {
    name = "Florian Ströger";
    email = "florian@florianstroeger.com";

    github = "Preisschild";
    githubId = 11898437;
  };
  priegger = {
    name = "Philipp Riegger";
    email = "philipp@riegger.name";

    github = "priegger";
    githubId = 228931;
  };
  prikhi = {
    name = "Pavan Rikhi";
    email = "pavan.rikhi@gmail.com";

    github = "prikhi";
    githubId = 1304102;
  };
  primeos = {
    name = "Michael Weiss";
    email = "dev.primeos@gmail.com";

    matrix = "@primeos:matrix.org";
    github = "primeos";
    githubId = 7537109;
    keys = [
      {
        fingerprint = "86A7 4A55 07D0 58D1 322E  37FD 1308 26A6 C2A3 89FD";
      }

      {
        fingerprint = "AF85 991C C950 49A2 4205  1933 BCA9 943D D1DF 4C04";
      }
    ];
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
  ProducerMatt = {
    name = "Matthew Pherigo";
    email = "ProducerMatt42@gmail.com";

    github = "ProducerMatt";
    githubId = 58014742;
  };
  Profpatsch = {
    name = "Profpatsch";
    email = "mail@profpatsch.de";

    github = "Profpatsch";
    githubId = 3153638;
  };
  proglodyte = {
    name = "Proglodyte";
    email = "proglodyte23@gmail.com";

    github = "proglodyte";
    githubId = 18549627;
  };
  progval = {
    name = "Valentin Lorentz";
    email = "progval+nix@progval.net";

    github = "progval";
    githubId = 406946;
  };
  proofofkeags = {
    name = "Keagan McClelland";
    email = "keagan.mcclelland@gmail.com";

    github = "ProofOfKeags";
    githubId = 4033651;
  };
  protoben = {
    name = "Ben Hamlin";
    email = "protob3n@gmail.com";

    github = "protoben";
    githubId = 4633847;
  };
  prtzl = {
    name = "Matej Blagsic";
    email = "matej.blagsic@protonmail.com";

    github = "prtzl";
    githubId = 32430344;
  };
  prusnak = {
    name = "Pavol Rusnak";
    email = "pavol@rusnak.io";

    github = "prusnak";
    githubId = 42201;
    keys = [{
      fingerprint = "86E6 792F C27B FD47 8860  C110 91F3 B339 B9A0 2A3D";
    }];
  };
  psanford = {
    name = "Peter Sanford";
    email = "psanford@sanford.io";

    github = "psanford";
    githubId = 33375;
  };
  pshirshov = {
    name = "Pavel Shirshov";
    email = "pshirshov@eml.cc";

    github = "pshirshov";
    githubId = 295225;
  };
  psibi = {
    name = "Sibi Prabakaran";
    email = "sibi@psibi.in";

    matrix = "@psibi:matrix.org";
    github = "psibi";
    githubId = 737477;
  };
  pstn = {
    name = "Philipp Steinpaß";
    email = "philipp@xndr.de";

    github = "pstn";
    githubId = 1329940;
  };
  pSub = {
    name = "Pascal Wittmann";
    email = "mail@pascal-wittmann.de";

    github = "pSub";
    githubId = 83842;
  };
  psyanticy = {
    name = "Psyanticy";
    email = "iuns@outlook.fr";

    github = "PsyanticY";
    githubId = 20524473;
  };
  psydvl = {
    name = "Dmitriy P";
    email = "psydvl@fea.st";

    github = "psydvl";
    githubId = 43755002;
  };
  ptival = {
    name = "Valentin Robert";
    email = "valentin.robert.42@gmail.com";

    github = "Ptival";
    githubId = 478606;
  };
  ptrhlm = {
    name = "Piotr Halama";
    email = "ptrhlm0@gmail.com";

    github = "ptrhlm";
    githubId = 9568176;
  };
  puckipedia = {
    name = "Puck Meerburg";
    email = "puck@puckipedia.com";

    github = "puckipedia";
    githubId = 488734;
  };
  puffnfresh = {
    name = "Brian McKenna";
    email = "brian@brianmckenna.org";

    github = "puffnfresh";
    githubId = 37715;
  };
  pulsation = {
    name = "Philippe Sam-Long";
    email = "1838397+pulsation@users.noreply.github.com";

    github = "pulsation";
    githubId = 1838397;
  };
  purcell = {
    name = "Steve Purcell";
    email = "steve@sanityinc.com";

    github = "purcell";
    githubId = 5636;
  };
  putchar = {
    name = "Slim Cadoux";
    email = "slim.cadoux@gmail.com";

    matrix = "@putch4r:matrix.org";
    github = "putchar";
    githubId = 8208767;
  };
  puzzlewolf = {
    name = "Nora Widdecke";
    email = "nixos@nora.pink";

    github = "puzzlewolf";
    githubId = 23097564;
  };
  pwoelfel = {
    name = "Philipp Woelfel";
    email = "philipp.woelfel@gmail.com";

    github = "PhilippWoelfel";
    githubId = 19400064;
  };
  pyrolagus = {
    name = "Danny Bautista";
    email = "pyrolagus@gmail.com";

    github = "PyroLagus";
    githubId = 4579165;
  };
  q3k = {
    name = "Serge Bazanski";
    email = "q3k@q3k.org";

    github = "q3k";
    githubId = 315234;
  };
  qbit = {
    name = "Aaron Bieber";
    email = "aaron@bolddaemon.com";

    matrix = "@qbit:tapenet.org";
    github = "qbit";
    githubId = 68368;
    keys = [{
      fingerprint = "3586 3350 BFEA C101 DB1A 4AF0 1F81 112D 62A9 ADCE";
    }];
  };
  qknight = {
    name = "Joachim Schiele";
    email = "js@lastlog.de";

    github = "qknight";
    githubId = 137406;
  };
  qoelet = {
    name = "Kenny Shen";
    email = "kenny@machinesung.com";

    github = "qoelet";
    githubId = 115877;
  };
  quag = {
    name = "Jonathan Wright";
    email = "quaggy@gmail.com";

    github = "quag";
    githubId = 35086;
  };
  quantenzitrone = {
    name = "quantenzitrone";
    email = "quantenzitrone@protonmail.com";

    matrix = "@quantenzitrone:matrix.org";
    github = "Quantenzitrone";
    githubId = 74491719;
  };
  queezle = {
    name = "Jens Nolte";
    email = "git@queezle.net";

    github = "queezle42";
    githubId = 1024891;
  };
  quentini = {
    name = "Quentin Inkling";
    email = "quentini@airmail.cc";

    github = "QuentinI";
    githubId = 18196237;
  };
  qyliss = {
    name = "Alyssa Ross";
    email = "hi@alyssa.is";

    github = "alyssais";
    githubId = 2768870;
    keys = [{
      fingerprint = "7573 56D7 79BB B888 773E  415E 736C CDF9 EF51 BD97";
    }];
  };
  r-burns = {
    name = "Ryan Burns";
    email = "rtburns@protonmail.com";

    github = "r-burns";
    githubId = 52847440;
  };
  r3dl3g = {
    name = "Armin Rothfuss";
    email = "redleg@rothfuss-web.de";

    github = "r3dl3g";
    githubId = 35229674;
  };
  raboof = {
    name = "Arnout Engelen";
    email = "arnout@bzzt.net";

    matrix = "@raboof:matrix.org";
    github = "raboof";
    githubId = 131856;
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
  rafaelgg = {
    name = "Rafael García";
    email = "rafael.garcia.gallego@gmail.com";

    github = "rafaelgg";
    githubId = 1016742;
  };
  ragge = {
    name = "Ragnar Dahlen";
    email = "r.dahlen@gmail.com";

    github = "ragnard";
    githubId = 882;
  };
  RaghavSood = {
    name = "Raghav Sood";
    email = "r@raghavsood.com";

    github = "RaghavSood";
    githubId = 903072;
  };
  raitobezarius = {
    name = "Ryan Lahfa";
    email = "ryan@lahfa.xyz";

    matrix = "@raitobezarius:matrix.org";
    github = "RaitoBezarius";
    githubId = 314564;
  };
  rakesh4g = {
    name = "Rakesh Gupta";
    email = "rakeshgupta4u@gmail.com";

    github = "Rakesh4G";
    githubId = 50867187;
  };
  ralith = {
    name = "Benjamin Saunders";
    email = "ben.e.saunders@gmail.com";

    matrix = "@ralith:ralith.com";
    github = "Ralith";
    githubId = 104558;
  };
  ramkromberg = {
    name = "Ram Kromberg";
    email = "ramkromberg@mail.com";

    github = "RamKromberg";
    githubId = 14829269;
  };
  ranfdev = {
    name = "Lorenzo Miglietta";
    email = "ranfdev@gmail.com";

    github = "ranfdev";
    githubId = 23294184;
  };
  raphaelr = {
    name = "Raphael Robatsch";
    email = "raphael-git@tapesoftware.net";

    matrix = "@raphi:tapesoftware.net";
    github = "raphaelr";
    githubId = 121178;
  };
  raquelgb = {
    name = "Raquel García";
    email = "raquel.garcia.bautista@gmail.com";

    github = "raquelgb";
    githubId = 1246959;
  };
  rardiol = {
    name = "Ricardo Ardissone";
    email = "ricardo.ardissone@gmail.com";

    github = "rardiol";
    githubId = 11351304;
  };
  rasendubi = {
    name = "Alexey Shmalko";
    email = "rasen.dubi@gmail.com";

    github = "rasendubi";
    githubId = 1366419;
  };
  raskin = {
    name = "Michael Raskin";
    email = "7c6f434c@mail.ru";

    github = "7c6f434c";
    githubId = 1891350;
  };
  ratsclub = {
    name = "Victor Freire";
    email = "victor@freire.dev.br";

    github = "vtrf";
    githubId = 25647735;
  };
  rawkode = {
    name = "David McKay";
    email = "david.andrew.mckay@gmail.com";

    github = "rawkode";
    githubId = 145816;
  };
  razvan = {
    name = "Răzvan Flavius Panda";
    email = "razvan.panda@gmail.com";

    github = "razvan-flavius-panda";
    githubId = 1758708;
  };
  rb = {
    name = "RB";
    email = "maintainers@cloudposse.com";

    github = "nitrocode";
    githubId = 7775707;
  };
  rb2k = {
    name = "Marc Seeger";
    email = "nix@marc-seeger.com";

    github = "rb2k";
    githubId = 9519;
  };
  rbasso = {
    name = "Rafael Basso";
    email = "rbasso@sharpgeeks.net";

    github = "rbasso";
    githubId = 16487165;
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
    name = "Rob Brewer";
    email = "rwb123@gmail.com";

    github = "rbrewer123";
    githubId = 743058;
  };
  rdnetto = {
    name = "Reuben D'Netto";
    email = "rdnetto@gmail.com";

    github = "rdnetto";
    githubId = 1973389;
  };
  realsnick = {
    name = "Ido Samuelson";
    email = "ido.samuelson@gmail.com";

    github = "realsnick";
    githubId = 1440852;
  };
  reckenrode = {
    name = "Randy Eckenrode";
    email = "randy@largeandhighquality.com";

    matrix = "@reckenrode:matrix.org";
    github = "reckenrode";
    githubId = 7413633;
    keys = [{
      fingerprint = "01D7 5486 3A6D 64EA AC77 0D26 FBF1 9A98 2CCE 0048";
    }];
  };
  redbaron = {
    name = "Maxim Ivanov";
    email = "ivanov.maxim@gmail.com";

    github = "redbaron";
    githubId = 16624;
  };
  redfish64 = {
    name = "Tim Engler";
    email = "engler@gmail.com";

    github = "redfish64";
    githubId = 1922770;
  };
  redvers = {
    name = "Redvers Davies";
    email = "red@infect.me";

    github = "redvers";
    githubId = 816465;
  };
  reedrw = {
    name = "Reed Williams";
    email = "reedrw5601@gmail.com";

    github = "reedrw";
    githubId = 21069876;
  };
  refnil = {
    name = "Martin Lavoie";
    email = "broemartino@gmail.com";

    github = "refnil";
    githubId = 1142322;
  };
  regadas = {
    name = "Filipe Regadas";
    email = "oss@regadas.email";

    github = "regadas";
    githubId = 163899;
  };
  regnat = {
    name = "Théophane Hufschmitt";
    email = "regnat@regnat.ovh";

    github = "thufschmitt";
    githubId = 7226587;
  };
  rehno-lindeque = {
    name = "Rehno Lindeque";
    email = "rehno.lindeque+code@gmail.com";

    github = "rehno-lindeque";
    githubId = 337811;
  };
  relrod = {
    name = "Ricky Elrod";
    email = "ricky@elrod.me";

    github = "relrod";
    githubId = 43930;
  };
  rembo10 = {
    name = "rembo10";
    email = "rembo10@users.noreply.github.com";

    github = "rembo10";
    githubId = 801525;
  };
  renatoGarcia = {
    name = "Renato Garcia";
    email = "fgarcia.renato@gmail.com";

    github = "renatoGarcia";
    githubId = 220211;
  };
  rencire = {
    name = "Eric Ren";
    email = "546296+rencire@users.noreply.github.com";

    github = "rencire";
    githubId = 546296;
  };
  renesat = {
    name = "Ivan Smolyakov";
    email = "smol.ivan97@gmail.com";

    github = "renesat";
    githubId = 11363539;
  };
  renzo = {
    name = "Renzo Carbonara";
    email = "renzocarbonara@gmail.com";

    github = "k0001";
    githubId = 3302;
  };
  retrry = {
    name = "Tadas Barzdžius";
    email = "retrry@gmail.com";

    github = "retrry";
    githubId = 500703;
  };
  revol-xut = {
    name = "Tassilo Tanneberger";
    email = "revol-xut@protonmail.com";

    github = "revol-xut";
    githubId = 32239737;
    keys = [{
      fingerprint = "91EB E870 1639 1323 642A  6803 B966 009D 57E6 9CC6";
    }];
  };
  rewine = {
    name = "Lu Hongxu";
    email = "lhongxu@outlook.com";

    github = "wineee";
    githubId = 22803888;
  };
  rexim = {
    name = "Alexey Kutepov";
    email = "reximkut@gmail.com";

    github = "rexim";
    githubId = 165283;
  };
  rgnns = {
    name = "Gabriel Lievano";
    email = "jglievano@gmail.com";

    github = "rgnns";
    githubId = 811827;
  };
  rgrinberg = {
    name = "Rudi Grinberg";
    email = "me@rgrinberg.com";

    github = "rgrinberg";
    githubId = 139003;
  };
  rgrunbla = {
    name = "Rémy Grünblatt";
    email = "remy@grunblatt.org";

    github = "rgrunbla";
    githubId = 42433779;
  };
  rguevara84 = {
    name = "Ricardo Guevara";
    email = "fuzztkd@gmail.com";

    github = "rguevara84";
    githubId = 12279531;
  };
  rhoriguchi = {
    name = "Ryan Horiguchi";
    email = "ryan.horiguchi@gmail.com";

    github = "rhoriguchi";
    githubId = 6047658;
  };
  rht = {
    name = "rht";
    email = "rhtbot@protonmail.com";

    github = "rht";
    githubId = 395821;
  };
  rhysmdnz = {
    name = "Rhys Davies";
    email = "rhys@memes.nz";

    matrix = "@rhys:memes.nz";
    github = "rhysmdnz";
    githubId = 2162021;
  };
  ribose-jeffreylau = {
    name = "Jeffrey Lau";
    email = "jeffrey.lau@ribose.com";

    github = "ribose-jeffreylau";
    githubId = 2649467;
  };
  richardipsum = {
    name = "Richard Ipsum";
    email = "richardipsum@fastmail.co.uk";

    github = "richardipsum";
    githubId = 10631029;
  };
  rick68 = {
    name = "Wei-Ming Yang";
    email = "rick68@gmail.com";

    github = "rick68";
    githubId = 42619;
  };
  rickynils = {
    name = "Rickard Nilsson";
    email = "rickynils@gmail.com";

    github = "rickynils";
    githubId = 16779;
  };
  ricochet = {
    name = "Bailey Hayes";
    email = "behayes2@gmail.com";

    matrix = "@ricochetcode:matrix.org";
    github = "ricochet";
    githubId = 974323;
  };
  riey = {
    name = "Riey";
    email = "creeper844@gmail.com";

    github = "Riey";
    githubId = 14910534;
  };
  rika = {
    name = "Rika";
    email = "rika@paymentswit.ch";

    github = "NekomimiScience";
    githubId = 1810487;
  };
  rileyinman = {
    name = "Riley Inman";
    email = "rileyminman@gmail.com";

    github = "rileyinman";
    githubId = 37246692;
  };
  riotbib = {
    name = "Lennart Mühlenmeier";
    email = "github-nix@lnrt.de";

    github = "riotbib";
    githubId = 43172581;
  };
  ris = {
    name = "Robert Scott";
    email = "code@humanleg.org.uk";

    github = "risicle";
    githubId = 807447;
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
    name = "Cedric Cellier";
    email = "rixed-github@happyleptic.org";

    github = "rixed";
    githubId = 449990;
  };
  rizary = {
    name = "Andika Demas Riyandi";
    email = "andika@numtide.com";

    github = "Rizary";
    githubId = 7221768;
  };
  rkitover = {
    name = "Rafael Kitover";
    email = "rkitover@gmail.com";

    github = "rkitover";
    githubId = 77611;
  };
  rkoe = {
    name = "Roland Koebler";
    email = "rk@simple-is-better.org";

    github = "rkoe";
    githubId = 2507744;
  };
  rkrzr = {
    name = "Robert Kreuzer";
    email = "ops+nixpkgs@channable.com";

    github = "rkrzr";
    githubId = 82817;
  };
  rlupton20 = {
    name = "Richard Lupton";
    email = "richard.lupton@gmail.com";

    github = "rlupton20";
    githubId = 13752145;
  };
  rmcgibbo = {
    name = "Robert T. McGibbon";
    email = "rmcgibbo@gmail.com";

    matrix = "@rmcgibbo:matrix.org";
    github = "rmcgibbo";
    githubId = 641278;
  };
  rnhmjoj = {
    name = "Michele Guerini Rocco";
    email = "rnhmjoj@inventati.org";

    matrix = "@rnhmjoj:maxwell.ydns.eu";
    github = "rnhmjoj";
    githubId = 2817565;
    keys = [{
      fingerprint = "92B2 904F D293 C94D C4C9  3E6B BFBA F4C9 75F7 6450";
    }];
  };
  roastiek = {
    name = "Rostislav Beneš";
    email = "r.dee.b.b@gmail.com";

    github = "roastiek";
    githubId = 422802;
  };
  rob = {
    name = "Rob Vermaas";
    email = "rob.vermaas@gmail.com";

    github = "rbvermaa";
    githubId = 353885;
  };
  robaca = {
    name = "Carsten Rohrbach";
    email = "carsten@r0hrbach.de";

    github = "robaca";
    githubId = 580474;
  };
  robberer = {
    name = "Longrin Wischnewski";
    email = "robberer@freakmail.de";

    github = "robberer";
    githubId = 6204883;
  };
  robbinch = {
    name = "Robbin C.";
    email = "robbinch33@gmail.com";

    github = "robbinch";
    githubId = 12312980;
  };
  robbins = {
    name = "Nathanael Robbins";
    email = "nejrobbins@gmail.com";

    github = "robbins";
    githubId = 31457698;
  };
  roberth = {
    name = "Robert Hensing";
    email = "nixpkgs@roberthensing.nl";

    matrix = "@roberthensing:matrix.org";
    github = "roberth";
    githubId = 496447;
  };
  robertodr = {
    name = "Roberto Di Remigio";
    email = "roberto.diremigio@gmail.com";

    github = "robertodr";
    githubId = 3708689;
  };
  robertoszek = {
    name = "Roberto";
    email = "robertoszek@robertoszek.xyz";

    github = "robertoszek";
    githubId = 1080963;
  };
  robgssp = {
    name = "Rob Glossop";
    email = "robgssp@gmail.com";

    github = "robgssp";
    githubId = 521306;
  };
  roblabla = {
    name = "Robin Lambertz";
    email = "robinlambertz+dev@gmail.com";

    github = "roblabla";
    githubId = 1069318;
  };
  roconnor = {
    name = "Russell O'Connor";
    email = "roconnor@theorem.ca";

    github = "roconnor";
    githubId = 852967;
  };
  rodrgz = {
    name = "Erik Rodriguez";
    email = "erik@rodgz.com";

    github = "rodrgz";
    githubId = 53882428;
  };
  roelvandijk = {
    name = "Roel van Dijk";
    email = "roel@lambdacube.nl";

    github = "roelvandijk";
    githubId = 710906;
  };
  romildo = {
    name = "José Romildo Malaquias";
    email = "malaquias@gmail.com";

    github = "romildo";
    githubId = 1217934;
  };
  ronanmacf = {
    name = "Ronan Mac Fhlannchadha";
    email = "macfhlar@tcd.ie";

    github = "RonanMacF";
    githubId = 25930627;
  };
  rongcuid = {
    name = "Rongcui Dong";
    email = "rongcuid@outlook.com";

    github = "rongcuid";
    githubId = 1312525;
  };
  roosemberth = {
    name = "Roosembert (Roosemberth) Palacios";
    email = "roosembert.palacios+nixpkgs@posteo.ch";

    matrix = "@roosemberth:orbstheorem.ch";
    github = "roosemberth";
    githubId = 3621083;
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
  RossComputerGuy = {
    name = "Tristan Ross";
    email = "tristan.ross@midstall.com";

    github = "RossComputerGuy";
    githubId = 19699320;
  };
  rowanG077 = {
    name = "Rowan Goemans";
    email = "goemansrowan@gmail.com";

    github = "rowanG077";
    githubId = 7439756;
  };
  royneary = {
    name = "Christian Ulrich";
    email = "christian@ulrich.earth";

    github = "royneary";
    githubId = 1942810;
  };
  rpearce = {
    name = "Robert W. Pearce";
    email = "me@robertwpearce.com";

    github = "rpearce";
    githubId = 592876;
  };
  rprecenth = {
    name = "Rasmus Précenth";
    email = "rasmus@precenth.eu";

    github = "Prillan";
    githubId = 1675190;
  };
  rprospero = {
    name = "Adam Washington";
    email = "rprospero+nix@gmail.com";

    github = "rprospero";
    githubId = 1728853;
  };
  rps = {
    name = "Robert P. Seaton";
    email = "robbpseaton@gmail.com";

    github = "robertseaton";
    githubId = 221121;
  };
  rraval = {
    name = "Ronuk Raval";
    email = "ronuk.raval@gmail.com";

    github = "rraval";
    githubId = 373566;
  };
  rrbutani = {
    name = "Rahul Butani";
    email = "rrbutani+nix@gmail.com";

    github = "rrbutani";
    githubId = 7833358;
    keys = [{
      fingerprint = "7DCA 5615 8AB2 621F 2F32  9FF4 1C7C E491 479F A273";
    }];
  };
  rski = {
    name = "rski";
    email = "rom.skiad+nix@gmail.com";

    github = "rski";
    githubId = 2960312;
  };
  rsynnest = {
    name = "Roland Synnestvedt";
    email = "contact@rsynnest.com";

    github = "rsynnest";
    githubId = 4392850;
  };
  rszibele = {
    name = "Richard Szibele";
    email = "richard@szibele.com";

    github = "rszibele";
    githubId = 1387224;
  };
  rtburns-jpl = {
    name = "Ryan Burns";
    email = "rtburns@jpl.nasa.gov";

    github = "rtburns-jpl";
    githubId = 47790121;
  };
  rtreffer = {
    name = "Rene Treffer";
    email = "treffer+nixos@measite.de";

    github = "rtreffer";
    githubId = 61306;
  };
  rushmorem = {
    name = "Rushmore Mushambi";
    email = "rushmore@webenchanter.com";

    github = "rushmorem";
    githubId = 4958190;
  };
  russell = {
    name = "Russell Sim";
    email = "russell.sim@gmail.com";

    github = "russell";
    githubId = 2660;
  };
  ruuda = {
    name = "Ruud van Asseldonk";
    email = "dev+nix@veniogames.com";

    github = "ruuda";
    githubId = 506953;
  };
  rvarago = {
    name = "Rafael Varago";
    email = "rafael.varago@gmail.com";

    github = "rvarago";
    githubId = 7365864;
  };
  rvl = {
    name = "Rodney Lorrimar";
    email = "dev+nix@rodney.id.au";

    github = "rvl";
    githubId = 1019641;
  };
  rvlander = {
    name = "Gaëtan André";
    email = "rvlander@gaetanandre.eu";

    github = "rvlander";
    githubId = 5236428;
  };
  rvolosatovs = {
    name = "Roman Volosatovs";
    email = "rvolosatovs@riseup.net";

    github = "rvolosatovs";
    githubId = 12877905;
  };
  ryanartecona = {
    name = "Ryan Artecona";
    email = "ryanartecona@gmail.com";

    github = "ryanartecona";
    githubId = 889991;
  };
  ryanorendorff = {
    name = "Ryan Orendorff";
    email = "12442942+ryanorendorff@users.noreply.github.com";

    github = "ryanorendorff";
    githubId = 12442942;
  };
  ryansydnor = {
    name = "Ryan Sydnor";
    email = "ryan.t.sydnor@gmail.com";

    github = "ryansydnor";
    githubId = 1832096;
  };
  ryantm = {
    name = "Ryan Mulligan";
    email = "ryan@ryantm.com";

    matrix = "@ryantm:matrix.org";
    github = "ryantm";
    githubId = 4804;
  };
  ryantrinkle = {
    name = "Ryan Trinkle";
    email = "ryan.trinkle@gmail.com";

    github = "ryantrinkle";
    githubId = 1156448;
  };
  rybern = {
    name = "Ryan Bernstein";
    email = "ryan.bernstein@columbia.edu";

    github = "rybern";
    githubId = 4982341;
  };
  rycee = {
    name = "Robert Helgesson";
    email = "robert@rycee.net";

    github = "rycee";
    githubId = 798147;
    keys = [{
      fingerprint = "36CA CF52 D098 CC0E 78FB  0CB1 3573 356C 25C4 24D4";
    }];
  };
  ryneeverett = {
    name = "Ryne Everett";
    email = "ryneeverett@gmail.com";

    github = "ryneeverett";
    githubId = 3280280;
  };
  rytone = {
    name = "Maxwell Beck";
    email = "max@ryt.one";

    github = "rastertail";
    githubId = 8082305;
    keys = [{
      fingerprint = "D260 79E3 C2BC 2E43 905B  D057 BB3E FA30 3760 A0DB";
    }];
  };
  rzetterberg = {
    name = "Richard Zetterberg";
    email = "richard.zetterberg@gmail.com";

    github = "rzetterberg";
    githubId = 766350;
  };
  s1341 = {
    name = "Shmarya Rubenstein";
    email = "s1341@shmarya.net";

    matrix = "@s1341:matrix.org";
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
    name = "Sam Alws";
    email = "sam@samalws.com";

    github = "samalws";
    githubId = 20981725;
  };
  samb96 = {
    name = "Sam Bickley";
    email = "samb96@gmail.com";

    github = "samb96";
    githubId = 819426;
  };
  samdoshi = {
    name = "Sam Doshi";
    email = "sam@metal-fish.co.uk";

    github = "samdoshi";
    githubId = 112490;
  };
  samdroid-apps = {
    name = "Sam Parkinson";
    email = "sam@sam.today";

    github = "samdroid-apps";
    githubId = 6022042;
  };
  samlich = {
    name = "samlich";
    email = "nixos@samli.ch";

    github = "samlich";
    githubId = 1349989;
    keys = [{
      fingerprint = "AE8C 0836 FDF6 3FFC 9580  C588 B156 8953 B193 9F1C";
    }];
  };
  samlukeyes123 = {
    name = "Sam L. Yes";
    email = "samlukeyes123@gmail.com";

    github = "SamLukeYes";
    githubId = 12882091;
  };
  samrose = {
    name = "Sam Rose";
    email = "samuel.rose@gmail.com";

    github = "samrose";
    githubId = 115821;
  };
  samuela = {
    name = "Samuel Ainsworth";
    email = "skainsworth@gmail.com";

    github = "samuela";
    githubId = 226872;
  };
  samueldr = {
    name = "Samuel Dionne-Riel";
    email = "samuel@dionne-riel.com";

    matrix = "@samueldr:matrix.org";
    github = "samueldr";
    githubId = 132835;
  };
  samuelrivas = {
    name = "Samuel Rivas";
    email = "samuelrivas@gmail.com";

    github = "samuelrivas";
    githubId = 107703;
  };
  samw = {
    name = "Sam Willcocks";
    email = "sam@wlcx.cc";

    github = "wlcx";
    githubId = 3065381;
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
    name = "Sander van der Burg";
    email = "s.vanderburg@tudelft.nl";

    github = "svanderburg";
    githubId = 1153271;
  };
  sarcasticadmin = {
    name = "Robert James Hernandez";
    email = "rob@sarcasticadmin.com";

    github = "sarcasticadmin";
    githubId = 30531572;
  };
  sargon = {
    name = "Daniel Ehlers";
    email = "danielehlers@mindeye.net";

    github = "sargon";
    githubId = 178904;
  };
  saschagrunert = {
    name = "Sascha Grunert";
    email = "mail@saschagrunert.de";

    github = "saschagrunert";
    githubId = 695473;
  };
  saulecabrera = {
    name = "Saúl Cabrera";
    email = "saulecabrera@gmail.com";

    github = "saulecabrera";
    githubId = 1423601;
  };
  sauyon = {
    name = "Sauyon Lee";
    email = "s@uyon.co";

    github = "sauyon";
    githubId = 2347889;
  };
  savannidgerinel = {
    name = "Savanni D'Gerinel";
    email = "savanni@luminescent-dreams.com";

    github = "savannidgerinel";
    githubId = 8534888;
  };
  sayanarijit = {
    name = "Arijit Basu";
    email = "sayanarijit@gmail.com";

    github = "sayanarijit";
    githubId = 11632726;
  };
  sb0 = {
    name = "Sébastien Bourdeauducq";
    email = "sb@m-labs.hk";

    github = "sbourdeauducq";
    githubId = 720864;
  };
  sbellem = {
    name = "Sylvain Bellemare";
    email = "sbellem@gmail.com";

    github = "sbellem";
    githubId = 125458;
  };
  sbond75 = {
    name = "sbond75";
    email = "43617712+sbond75@users.noreply.github.com";

    github = "sbond75";
    githubId = 43617712;
  };
  sboosali = {
    name = "Sam Boosalis";
    email = "SamBoosalis@gmail.com";

    github = "sboosali";
    githubId = 2320433;
  };
  sbruder = {
    name = "Simon Bruder";
    email = "nixos@sbruder.de";

    github = "sbruder";
    githubId = 15986681;
  };
  scalavision = {
    name = "Tom Sorlie";
    email = "scalavision@gmail.com";

    github = "scalavision";
    githubId = 3958212;
  };
  schmitthenner = {
    name = "Fabian Schmitthenner";
    email = "development@schmitthenner.eu";

    github = "fkz";
    githubId = 354463;
  };
  schmittlauch = {
    name = "Trolli Schmittlauch";
    email = "t.schmittlauch+nixos@orlives.de";

    github = "schmittlauch";
    githubId = 1479555;
  };
  schneefux = {
    name = "schneefux";
    email = "schneefux+nixos_pkg@schneefux.xyz";

    github = "schneefux";
    githubId = 15379000;
  };
  schnusch = {
    name = "schnusch";
    email = "schnusch@users.noreply.github.com";

    github = "schnusch";
    githubId = 5104601;
  };
  sciencentistguy = {
    name = "Jamie Quigley";
    email = "jamie@quigley.xyz";

    github = "Sciencentistguy";
    githubId = 4983935;
    keys = [{
      fingerprint = "30BB FF3F AB0B BB3E 0435  F83C 8E8F F66E 2AE8 D970";
    }];
  };
  scode = {
    name = "Peter Schuller";
    email = "peter.schuller@infidyne.com";

    github = "scode";
    githubId = 59476;
  };
  scoder12 = {
    name = "Spencer Pogorzelski";
    email = "34356756+Scoder12@users.noreply.github.com";

    github = "Scoder12";
    githubId = 34356756;
  };
  scolobb = {
    name = "Sergiu Ivanov";
    email = "sivanov@colimite.fr";

    github = "scolobb";
    githubId = 11320;
  };
  screendriver = {
    name = "Christian Rackerseder";
    email = "nix@echooff.de";

    github = "screendriver";
    githubId = 149248;
  };
  Scriptkiddi = {
    name = "Fritz Otlinghaus";
    email = "nixos@scriptkiddi.de";

    matrix = "@fritz.otlinghaus:helsinki-systems.de";
    github = "Scriptkiddi";
    githubId = 3598650;
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
    name = "Sterling Stein";
    email = "scubed2@gmail.com";

    github = "scubed2";
    githubId = 7401858;
  };
  sdier = {
    name = "Scott Dier";
    email = "scott@dier.name";

    matrix = "@sdier:matrix.org";
    github = "sdier";
    githubId = 11613056;
  };
  SeanZicari = {
    name = "Sean Zicari";
    email = "sean.zicari@gmail.com";

    github = "SeanZicari";
    githubId = 2343853;
  };
  seb314 = {
    name = "Sebastian";
    email = "sebastian@seb314.com";

    github = "seb314";
    githubId = 19472270;
  };
  sebastianblunt = {
    name = "Sebastian Blunt";
    email = "nix@sebastianblunt.com";

    github = "sebastianblunt";
    githubId = 47431204;
  };
  sebbadk = {
    name = "Sebastian Hyberts";
    email = "sebastian@sebba.dk";

    github = "SEbbaDK";
    githubId = 1567527;
  };
  sebbel = {
    name = "Sebastian Ball";
    email = "hej@sebastian-ball.de";

    github = "sebbel";
    githubId = 1940568;
  };
  seberm = {
    name = "Otto Sabart";
    email = "seberm@seberm.com";

    github = "seberm";
    githubId = 212597;
    keys = [{
      fingerprint = "0AF6 4C3B 1F12 14B3 8C8C  5786 1FA2 DBE6 7438 7CC3";
    }];
  };
  sebtm = {
    name = "Sebastian Sellmeier";
    email = "mail@sebastian-sellmeier.de";

    github = "SebTM";
    githubId = 17243347;
  };
  sei40kr = {
    name = "Seong Yong-ju";
    email = "sei40kr@gmail.com";

    github = "sei40kr";
    githubId = 11665236;
  };
  sellout = {
    name = "Greg Pfeil";
    email = "greg@technomadic.org";

    github = "sellout";
    githubId = 33031;
  };
  sengaya = {
    name = "Thilo Uttendorfer";
    email = "tlo@sengaya.de";

    github = "sengaya";
    githubId = 1286668;
  };
  sephalon = {
    name = "Stefan Wiehler";
    email = "me@sephalon.net";

    github = "sephalon";
    githubId = 893474;
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
    name = "Raffael Mancini";
    email = "raffael@mancini.lu";

    github = "sepi";
    githubId = 529649;
  };
  seppeljordan = {
    name = "Sebastian Jordan";
    email = "sebastian.jordan.mail@googlemail.com";

    github = "seppeljordan";
    githubId = 4805746;
  };
  seqizz = {
    name = "Gurkan Gur";
    email = "seqizz@gmail.com";

    github = "seqizz";
    githubId = 307899;
  };
  serge = {
    name = "Serge Belov";
    email = "sb@canva.com";

    github = "serge-belov";
    githubId = 38824235;
  };
  sersorrel = {
    name = "ash";
    email = "ash@sorrel.sh";

    github = "sersorrel";
    githubId = 9433472;
  };
  servalcatty = {
    name = "Serval";
    email = "servalcat@pm.me";

    github = "servalcatty";
    githubId = 51969817;
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
    name = "Stefan Frijters";
    email = "sfrijters@gmail.com";

    github = "SFrijters";
    githubId = 918365;
  };
  sgo = {
    name = "Stig Palmquist";
    email = "stig@stig.io";

    github = "stigtsp";
    githubId = 75371;
  };
  sgraf = {
    name = "Sebastian Graf";
    email = "sgraf1337@gmail.com";

    github = "sgraf812";
    githubId = 1151264;
  };
  shadaj = {
    name = "Shadaj Laddad";
    email = "shadaj@users.noreply.github.com";

    github = "shadaj";
    githubId = 543055;
  };
  shadowrz = {
    name = "夜坂雅";
    email = "shadowrz+nixpkgs@disroot.org";

    matrix = "@ShadowRZ:matrixim.cc";
    github = "ShadowRZ";
    githubId = 23130178;
  };
  shahrukh330 = {
    name = "Shahrukh Khan";
    email = "shahrukh330@gmail.com";

    github = "shahrukh330";
    githubId = 1588288;
  };
  shamilton = {
    name = "Scott Hamilton";
    email = "sgn.hamilton@protonmail.com";

    github = "SCOTT-HAMILTON";
    githubId = 24496705;
  };
  ShamrockLee = {
    name = "Shamrock Lee";
    email = "44064051+ShamrockLee@users.noreply.github.com";

    github = "ShamrockLee";
    githubId = 44064051;
  };
  shanemikel = {
    name = "Shane Pearlman";
    email = "shanepearlman@pm.me";

    github = "shanemikel";
    githubId = 6720672;
  };
  shanesveller = {
    name = "Shane Sveller";
    email = "shane@sveller.dev";

    github = "shanesveller";
    githubId = 831;
    keys = [{
      fingerprint = "F83C 407C ADC4 5A0F 1F2F  44E8 9210 C218 023C 15CD";
    }];
  };
  shardy = {
    name = "Shardul Baral";
    email = "shardul@baral.ca";

    github = "shardulbee";
    githubId = 16765155;
  };
  shawn8901 = {
    name = "Shawn8901";
    email = "shawn8901@googlemail.com";

    github = "Shawn8901";
    githubId = 12239057;
  };
  shawndellysse = {
    name = "Shawn Dellysse";
    email = "sdellysse@gmail.com";

    github = "sdellysse";
    githubId = 293035;
  };
  shazow = {
    name = "Andrey Petrov";
    email = "andrey.petrov@shazow.net";

    github = "shazow";
    githubId = 6292;
  };
  sheenobu = {
    name = "Sheena Artrip";
    email = "sheena.artrip@gmail.com";

    github = "sheenobu";
    githubId = 1443459;
  };
  sheepforce = {
    name = "Phillip Seeber";
    email = "phillip.seeber@googlemail.com";

    github = "sheepforce";
    githubId = 16844216;
  };
  sheganinans = {
    name = "Aistis Raulinaitis";
    email = "sheganinans@gmail.com";

    github = "sheganinans";
    githubId = 2146203;
  };
  shell = {
    name = "Shell Turner";
    email = "cam.turn@gmail.com";

    github = "VShell";
    githubId = 251028;
  };
  shikanime = {
    name = "William Phetsinorath";
    email = "deva.shikanime@protonmail.com";

    github = "shikanime";
    githubId = 22115108;
  };
  shiryel = {
    name = "Shiryel";
    email = "contact@shiryel.com";

    github = "shiryel";
    githubId = 35617139;
    keys = [{
      fingerprint = "AB63 4CD9 3322 BD42 6231  F764 C404 1EA6 B326 33DE";
    }];
  };
  shlevy = {
    name = "Shea Levy";
    email = "shea@shealevy.com";

    github = "shlevy";
    githubId = 487050;
  };
  shmish111 = {
    name = "David Smith";
    email = "shmish111@gmail.com";

    github = "shmish111";
    githubId = 934267;
  };
  shnarazk = {
    name = "Narazaki Shuji";
    email = "shujinarazaki@protonmail.com";

    github = "shnarazk";
    githubId = 997855;
  };
  shofius = {
    name = "Sam Hofius";
    email = "sam@samhofi.us";

    github = "kf5grd";
    githubId = 18297490;
  };
  shou = {
    name = "Benedict Aas";
    email = "x+g@shou.io";

    github = "Shou";
    githubId = 819413;
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
    name = "Soner Sayakci";
    email = "s.sayakci@gmail.com";

    github = "shyim";
    githubId = 6224096;
  };
  siddharthist = {
    name = "Langston Barrett";
    email = "langston.barrett@gmail.com";

    github = "langston-barrett";
    githubId = 4294323;
  };
  sielicki = {
    name = "Nicholas Sielicki";
    email = "nix@opensource.nslick.com";

    matrix = "@sielicki:matrix.org";
    github = "sielicki";
    githubId = 4522995;
  };
  siers = {
    name = "Raitis Veinbahs";
    email = "veinbahs+nixpkgs@gmail.com";

    github = "siers";
    githubId = 235147;
  };
  sifmelcara = {
    name = "Ming Chuan";
    email = "ming@culpring.com";

    github = "sifmelcara";
    githubId = 10496191;
  };
  sigma = {
    name = "Yann Hodique";
    email = "yann.hodique@gmail.com";

    github = "sigma";
    githubId = 16090;
  };
  sikmir = {
    name = "Nikolay Korotkiy";
    email = "sikmir@disroot.org";

    github = "sikmir";
    githubId = 688044;
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
  simonchatts = {
    name = "Simon Chatterjee";
    email = "code@chatts.net";

    github = "simonchatts";
    githubId = 11135311;
  };
  simoneruffini = {
    name = "Simone Ruffini";
    email = "simone.ruffini@tutanota.com";

    github = "simoneruffini";
    githubId = 50401154;
  };
  simonkampe = {
    name = "Simon Kämpe";
    email = "simon.kampe+nix@gmail.com";

    github = "simonkampe";
    githubId = 254799;
  };
  simonvandel = {
    name = "Simon Vandel Sillesen";
    email = "simon.vandel@gmail.com";

    github = "simonvandel";
    githubId = 2770647;
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
  sir4ur0n = {
    name = "sir4ur0n";
    email = "sir4ur0n@users.noreply.github.com";

    github = "sir4ur0n";
    githubId = 1204125;
  };
  siraben = {
    name = "Siraphob Phipathananunth";
    email = "bensiraphob@gmail.com";

    matrix = "@siraben:matrix.org";
    github = "siraben";
    githubId = 8219659;
  };
  siriobalmelli = {
    name = "Sirio Balmelli";
    email = "sirio@b-ad.ch";

    github = "siriobalmelli";
    githubId = 23038812;
    keys = [{
      fingerprint = "B234 EFD4 2B42 FE81 EE4D  7627 F72C 4A88 7F9A 24CA";
    }];
  };
  sirseruju = {
    name = "Fofanov Sergey";
    email = "sir.seruju@yandex.ru";

    github = "SirSeruju";
    githubId = 74881555;
  };
  sivteck = {
    name = "Sivaram Balakrishnan";
    email = "sivaram1992@gmail.com";

    github = "sivteck";
    githubId = 8017899;
  };
  sjagoe = {
    name = "Simon Jagoe";
    email = "simon@simonjagoe.com";

    github = "sjagoe";
    githubId = 80012;
  };
  sjau = {
    name = "Stephan Jau";
    email = "nixos@sjau.ch";

    github = "sjau";
    githubId = 848812;
  };
  sjfloat = {
    name = "Steve Jones";
    email = "steve+nixpkgs@jonescape.com";

    github = "sjfloat";
    githubId = 216167;
  };
  sjmackenzie = {
    name = "Stewart Mackenzie";
    email = "setori88@gmail.com";

    github = "sjmackenzie";
    githubId = 158321;
  };
  skeidel = {
    name = "Sven Keidel";
    email = "svenkeidel@gmail.com";

    github = "svenkeidel";
    githubId = 266500;
  };
  skykanin = {
    name = "skykanin";
    email = "skykanin@users.noreply.github.com";

    github = "skykanin";
    githubId = 3789764;
  };
  sleexyz = {
    name = "Sean Lee";
    email = "freshdried@gmail.com";

    github = "sleexyz";
    githubId = 1505617;
  };
  SlothOfAnarchy = {
    name = "Michel Weitbrecht";
    email = "slothofanarchy1@gmail.com";

    matrix = "@michel.weitbrecht:helsinki-systems.de";
    github = "SlothOfAnarchy";
    githubId = 12828415;
  };
  smakarov = {
    name = "Sergey Makarov";
    email = "setser200018@gmail.com";

    github = "SeTSeR";
    githubId = 12733495;
    keys = [{
      fingerprint = "6F8A 18AE 4101 103F 3C54  24B9 6AA2 3A11 93B7 064B";
    }];
  };
  smancill = {
    name = "Sebastián Mancilla";
    email = "smancill@smancill.dev";

    github = "smancill";
    githubId = 238528;
  };
  smaret = {
    name = "Sébastien Maret";
    email = "sebastien.maret@icloud.com";

    github = "smaret";
    githubId = 95471;
    keys = [{
      fingerprint = "4242 834C D401 86EF 8281  4093 86E3 0E5A 0F5F C59C";
    }];
  };
  smasher164 = {
    name = "Akhil Indurti";
    email = "aindurti@gmail.com";

    github = "smasher164";
    githubId = 12636891;
  };
  smironov = {
    name = "Sergey Mironov";
    email = "grrwlf@gmail.com";

    github = "grwlf";
    githubId = 4477729;
  };
  smitop = {
    name = "Smitty van Bodegom";
    email = "me@smitop.com";

    matrix = "@smitop:kde.org";
    github = "Smittyvb";
    githubId = 10530973;
  };
  sna = {
    name = "S. Nordin Abouzahra";
    email = "abouzahra.9@wright.edu";

    github = "S-NA";
    githubId = 20214715;
  };
  snaar = {
    name = "Serguei Narojnyi";
    email = "snaar@snaar.net";

    github = "snaar";
    githubId = 602439;
  };
  snapdgn = {
    name = "Nitish Kumar";
    email = "snapdgn@proton.me";

    github = "snapdgn";
    githubId = 85608760;
  };
  snglth = {
    name = "Illia Shestakov";
    email = "illia@ishestakov.com";

    github = "snglth";
    githubId = 8686360;
  };
  snicket2100 = {
    name = "snicket2100";
    email = "57048005+snicket2100@users.noreply.github.com";

    github = "snicket2100";
    githubId = 57048005;
  };
  snpschaaf = {
    name = "Philippe Schaaf";
    email = "philipe.schaaf@secunet.com";

    github = "snpschaaf";
    githubId = 105843013;
  };
  snyh = {
    name = "Xia Bin";
    email = "snyh@snyh.org";

    github = "snyh";
    githubId = 1437166;
  };
  softinio = {
    name = "Salar Rahmanian";
    email = "code@softinio.com";

    github = "softinio";
    githubId = 3371635;
  };
  sohalt = {
    name = "sohalt";
    email = "nixos@sohalt.net";

    github = "Sohalt";
    githubId = 2157287;
  };
  SohamG = {
    name = "Soham S Gumaste";
    email = "sohamg2@gmail.com";

    github = "SohamG";
    githubId = 7116239;
    keys = [{
      fingerprint = "E067 520F 5EF2 C175 3F60  50C0 BA46 725F 6A26 7442";
    }];
  };
  solson = {
    name = "Scott Olson";
    email = "scott@solson.me";

    matrix = "@solson:matrix.org";
    github = "solson";
    githubId = 26806;
  };
  somasis = {
    name = "Kylie McClain";
    email = "kylie@somas.is";

    github = "somasis";
    githubId = 264788;
  };
  SomeoneSerge = {
    name = "Sergei K";
    email = "sergei.kozlukov@aalto.fi";

    matrix = "@ss:someonex.net";
    github = "SomeoneSerge";
    githubId = 9720532;
  };
  sophrosyne = {
    name = "Joshua Ortiz";
    email = "joshuaortiz@tutanota.com";

    github = "sophrosyne97";
    githubId = 53029739;
  };
  sorki = {
    name = "Richard Marko";
    email = "srk@48.io";

    github = "sorki";
    githubId = 115308;
  };
  sorpaas = {
    name = "Wei Tang";
    email = "hi@that.world";

    github = "sorpaas";
    githubId = 6277322;
  };
  spacefrogg = {
    name = "Michael Raitza";
    email = "spacefrogg-nixos@meterriblecrew.net";

    github = "spacefrogg";
    githubId = 167881;
  };
  spacekookie = {
    name = "Katharina Fey";
    email = "kookie@spacekookie.de";

    github = "spacekookie";
    githubId = 7669898;
  };
  spease = {
    name = "Steven Pease";
    email = "peasteven@gmail.com";

    github = "spease";
    githubId = 2825204;
  };
  spencerjanssen = {
    name = "Spencer Janssen";
    email = "spencerjanssen@gmail.com";

    matrix = "@sjanssen:matrix.org";
    github = "spencerjanssen";
    githubId = 2600039;
  };
  spinus = {
    name = "Tomasz Czyż";
    email = "tomasz.czyz@gmail.com";

    github = "spinus";
    githubId = 950799;
  };
  sprock = {
    name = "Roger Mason";
    email = "rmason@mun.ca";

    github = "sprock";
    githubId = 6391601;
  };
  spwhitt = {
    name = "Spencer Whitt";
    email = "sw@swhitt.me";

    github = "spwhitt";
    githubId = 1414088;
  };
  squalus = {
    name = "squalus";
    email = "squalus@squalus.net";

    github = "squalus";
    githubId = 36899624;
  };
  squarepear = {
    name = "Jeffrey Harmon";
    email = "contact@jeffreyharmon.dev";

    github = "SquarePear";
    githubId = 16364318;
  };
  srapenne = {
    name = "Solène Rapenne";
    email = "solene@perso.pw";

    github = "rapenne-s";
    githubId = 248016;
  };
  srghma = {
    name = "Sergei Khoma";
    email = "srghma@gmail.com";

    github = "srghma";
    githubId = 7573215;
  };
  srgom = {
    name = "SRGOM";
    email = "srgom@users.noreply.github.com";

    github = "SRGOM";
    githubId = 8103619;
  };
  srhb = {
    name = "Sarah Brofeldt";
    email = "sbrofeldt@gmail.com";

    matrix = "@srhb:matrix.org";
    github = "srhb";
    githubId = 219362;
  };
  SShrike = {
    name = "Severen Redwood";
    email = "severen@shrike.me";

    github = "severen";
    githubId = 4061736;
  };
  sstef = {
    name = "Stephane Schitter";
    email = "stephane@nix.frozenid.net";

    github = "haskelious";
    githubId = 8668915;
  };
  staccato = {
    name = "staccato";
    email = "moveq@riseup.net";

    github = "braaandon";
    githubId = 86573128;
  };
  stackshadow = {
    name = "Martin Langlotz";
    email = "stackshadow@evilbrain.de";

    github = "stackshadow";
    githubId = 7512804;
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
  stargate01 = {
    name = "Christoph Honal";
    email = "christoph.honal@web.de";

    github = "StarGate01";
    githubId = 6362238;
  };
  stasjok = {
    name = "Stanislav Asunkin";
    email = "nixpkgs@stasjok.ru";

    github = "stasjok";
    githubId = 1353637;
  };
  steamwalker = {
    name = "steamwalker";
    email = "steamwalker@xs4all.nl";

    github = "steamwalker";
    githubId = 94006354;
  };
  steell = {
    name = "Steve Elliott";
    email = "steve@steellworks.com";

    github = "Steell";
    githubId = 1699155;
  };
  stehessel = {
    name = "Stephan Heßelmann";
    email = "stephan@stehessel.de";

    github = "stehessel";
    githubId = 55607356;
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
    name = "Stel Abrego";
    email = "stel@stel.codes";

    github = "stelcodes";
    githubId = 22163194;
  };
  stephank = {
    name = "Stéphan Kochen";
    email = "nix@stephank.nl";

    matrix = "@skochen:matrix.org";
    github = "stephank";
    githubId = 89950;
  };
  stephenmw = {
    name = "Stephen Weinberg";
    email = "stephen@q5comm.com";

    github = "stephenmw";
    githubId = 231788;
  };
  stephenwithph = {
    name = "StephenWithPH";
    email = "StephenWithPH@users.noreply.github.com";

    github = "StephenWithPH";
    githubId = 2990492;
  };
  sterfield = {
    name = "Guillaume Loetscher";
    email = "sterfield@gmail.com";

    github = "sterfield";
    githubId = 5747061;
  };
  sternenseemann = {
    name = "Lukas Epple";
    email = "sternenseemann@systemli.org";

    github = "sternenseemann";
    githubId = 3154475;
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
    name = "Stefan Siegl";
    email = "stesie@brokenpipe.de";

    github = "stesie";
    githubId = 113068;
  };
  steve-chavez = {
    name = "Steve Chávez";
    email = "stevechavezast@gmail.com";

    github = "steve-chavez";
    githubId = 1829294;
  };
  stevebob = {
    name = "Stephen Sherratt";
    email = "stephen@sherra.tt";

    github = "gridbugs";
    githubId = 417118;
  };
  steveej = {
    name = "Stefan Junker";
    email = "mail@stefanjunker.de";

    github = "steveeJ";
    githubId = 1181362;
  };
  stevenroose = {
    name = "Steven Roose";
    email = "github@stevenroose.org";

    github = "stevenroose";
    githubId = 853468;
  };
  stianlagstad = {
    name = "Stian Lågstad";
    email = "stianlagstad@gmail.com";

    github = "stianlagstad";
    githubId = 4340859;
  };
  StijnDW = {
    name = "Stijn DW";
    email = "nixdev@rinsa.eu";

    github = "Stekke";
    githubId = 1751956;
  };
  StillerHarpo = {
    name = "Florian Engel";
    email = "florianengel39@gmail.com";

    github = "StillerHarpo";
    githubId = 25526706;
  };
  stites = {
    name = "Sam Stites";
    email = "sam@stites.io";

    github = "stites";
    githubId = 1694705;
  };
  strager = {
    name = "Matthew \"strager\" Glazar";
    email = "strager.nds@gmail.com";

    github = "strager";
    githubId = 48666;
  };
  strikerlulu = {
    name = "StrikerLulu";
    email = "strikerlulu7@gmail.com";

    github = "strikerlulu";
    githubId = 38893265;
  };
  stumoss = {
    name = "Stuart Moss";
    email = "samoss@gmail.com";

    github = "stumoss";
    githubId = 638763;
  };
  stunkymonkey = {
    name = "Felix Bühler";
    email = "account@buehler.rocks";

    github = "Stunkymonkey";
    githubId = 1315818;
  };
  stupremee = {
    name = "Justus K";
    email = "jutus.k@protonmail.com";

    github = "Stupremee";
    githubId = 39732259;
  };
  SubhrajyotiSen = {
    name = "Subhrajyoti Sen";
    email = "subhrajyoti12@gmail.com";

    github = "SubhrajyotiSen";
    githubId = 12984845;
  };
  sudosubin = {
    name = "Subin Kim";
    email = "sudosubin@gmail.com";

    github = "sudosubin";
    githubId = 32478597;
  };
  suhr = {
    name = "Сухарик";
    email = "suhr@i2pmail.org";

    github = "suhr";
    githubId = 65870;
  };
  sumnerevans = {
    name = "Sumner Evans";
    email = "me@sumnerevans.com";

    github = "sumnerevans";
    githubId = 16734772;
  };
  superbo = {
    name = "Y Nguyen";
    email = "supernbo@gmail.com";

    github = "SuperBo";
    githubId = 2666479;
  };
  SuperSandro2000 = {
    name = "Sandro Jäckel";
    email = "sandro.jaeckel@gmail.com";

    matrix = "@sandro:supersandro.de";
    github = "SuperSandro2000";
    githubId = 7258858;
  };
  SuprDewd = {
    name = "Bjarki Ágúst Guðmundsson";
    email = "suprdewd@gmail.com";

    github = "SuprDewd";
    githubId = 187109;
  };
  suryasr007 = {
    name = "Surya Teja V";
    email = "94suryateja@gmail.com";

    github = "suryasr007";
    githubId = 10533926;
  };
  suvash = {
    name = "Suvash Thapaliya";
    email = "suvash+nixpkgs@gmail.com";

    github = "suvash";
    githubId = 144952;
  };
  sveitser = {
    name = "Mathis Antony";
    email = "sveitser@gmail.com";

    github = "sveitser";
    githubId = 1040871;
  };
  sven-of-cord = {
    name = "Sven Over";
    email = "sven@cord.com";

    github = "sven-of-cord";
    githubId = 98333944;
  };
  svend = {
    name = "Svend Sorensen";
    email = "svend@svends.net";

    github = "svend";
    githubId = 306190;
  };
  svrana = {
    name = "Shaw Vrana";
    email = "shaw@vranix.com";

    github = "svrana";
    githubId = 850665;
  };
  svsdep = {
    name = "Vasyl Solovei";
    email = "svsdep@gmail.com";

    github = "svsdep";
    githubId = 36695359;
  };
  swarren83 = {
    name = "Shawn Warren";
    email = "shawn.w.warren@gmail.com";

    github = "swarren83";
    githubId = 4572854;
  };
  swdunlop = {
    name = "Scott W. Dunlop";
    email = "swdunlop@gmail.com";

    github = "swdunlop";
    githubId = 120188;
  };
  sweber = {
    name = "Simon Weber";
    email = "sweber2342+nixpkgs@gmail.com";

    github = "sweber83";
    githubId = 19905904;
  };
  sweenu = {
    name = "sweenu";
    email = "contact@sweenu.xyz";

    github = "sweenu";
    githubId = 7051978;
  };
  swflint = {
    name = "Samuel W. Flint";
    email = "swflint@flintfam.org";

    github = "swflint";
    githubId = 1771109;
  };
  swistak35 = {
    name = "Rafał Łasocha";
    email = "me@swistak35.com";

    github = "swistak35";
    githubId = 332289;
  };
  syberant = {
    name = "Sybrand Aarnoutse";
    email = "sybrand@neuralcoding.com";

    github = "syberant";
    githubId = 20063502;
  };
  symphorien = {
    name = "Guillaume Girol";
    email = "symphorien_nixpkgs@xlumurb.eu";

    matrix = "@symphorien:xlumurb.eu";
    github = "symphorien";
    githubId = 12595971;
  };
  synthetica = {
    name = "Patrick Hilhorst";
    email = "nix@hilhorst.be";

    github = "Synthetica9";
    githubId = 7075751;
  };
  szczyp = {
    name = "Szczyp";
    email = "qb@szczyp.com";

    github = "Szczyp";
    githubId = 203195;
  };
  szlend = {
    name = "Simon Žlender";
    email = "pub.nix@zlender.si";

    github = "szlend";
    githubId = 7301807;
  };
  sztupi = {
    name = "Attila Sztupak";
    email = "attila.sztupak@gmail.com";

    github = "sztupi";
    githubId = 143103;
  };
  t184256 = {
    name = "Alexander Sosedkin";
    email = "monk@unboiled.info";

    github = "t184256";
    githubId = 5991987;
  };
  tadeokondrak = {
    name = "Tadeo Kondrak";
    email = "me@tadeo.ca";

    github = "tadeokondrak";
    githubId = 4098453;
    keys = [{
      fingerprint = "0F2B C0C7 E77C 5B42 AC5B  4C18 FBE6 07FC C495 16D3";
    }];
  };
  tadfisher = {
    name = "Tad Fisher";
    email = "tadfisher@gmail.com";

    github = "tadfisher";
    githubId = 129148;
  };
  taeer = {
    name = "Taeer Bar-Yam";
    email = "taeer@necsi.edu";

    github = "Radvendii";
    githubId = 1239929;
  };
  taha = {
    name = "Taha Gharib";
    email = "xrcrod@gmail.com";

    github = "tgharib";
    githubId = 6457015;
  };
  taikx4 = {
    name = "taikx4";
    email = "taikx4@taikx4szlaj2rsdupcwabg35inbny4jk322ngeb7qwbbhd5i55nf5yyd.onion";

    github = "taikx4";
    githubId = 94917129;
    keys = [{
      fingerprint = "6B02 8103 C4E5 F68C D77C  9E54 CCD5 2C7B 37BB 837E";
    }];
  };
  tailhook = {
    name = "Paul Colomiets";
    email = "paul@colomiets.name";

    github = "tailhook";
    githubId = 321799;
  };
  takagiy = {
    name = "Yuki Takagi";
    email = "takagiy.4dev@gmail.com";

    github = "takagiy";
    githubId = 18656090;
  };
  taketwo = {
    name = "Sergey Alexandrov";
    email = "alexandrov88@gmail.com";

    github = "taketwo";
    githubId = 1241736;
  };
  takikawa = {
    name = "Asumu Takikawa";
    email = "asumu@igalia.com";

    github = "takikawa";
    githubId = 64192;
  };
  taktoa = {
    name = "Remy Goldschmidt";
    email = "taktoa@gmail.com";

    matrix = "@taktoa:matrix.org";
    github = "taktoa";
    githubId = 553443;
  };
  taku0 = {
    name = "Takuo Yonezawa";
    email = "mxxouy6x3m_github@tatapa.org";

    github = "taku0";
    githubId = 870673;
  };
  talkara = {
    name = "Taito Horiuchi";
    email = "taito.horiuchi@relexsolutions.com";

    github = "talkara";
    githubId = 51232929;
  };
  talyz = {
    name = "Kim Lindberger";
    email = "kim.lindberger@gmail.com";

    matrix = "@talyz:matrix.org";
    github = "talyz";
    githubId = 63433;
  };
  taneb = {
    name = "Nathan van Doorn";
    email = "nvd1234@gmail.com";

    github = "Taneb";
    githubId = 1901799;
  };
  tari = {
    name = "Peter Marheine";
    email = "peter@taricorp.net";

    github = "tari";
    githubId = 506181;
  };
  tasmo = {
    name = "Thomas Friese";
    email = "tasmo@tasmo.de";

    github = "tasmo";
    githubId = 102685;
  };
  taylor1791 = {
    name = "Taylor Everding";
    email = "nixpkgs@tayloreverding.com";

    github = "taylor1791";
    githubId = 555003;
  };
  tazjin = {
    name = "Vincent Ambo";
    email = "mail@tazj.in";

    github = "tazjin";
    githubId = 1552853;
  };
  tbenst = {
    name = "Tyler Benster";
    email = "nix@tylerbenster.com";

    github = "tbenst";
    githubId = 863327;
  };
  tboerger = {
    name = "Thomas Boerger";
    email = "thomas@webhippie.de";

    matrix = "@tboerger:matrix.org";
    github = "tboerger";
    githubId = 156964;
  };
  tcbravo = {
    name = "Tomas Bravo";
    email = "tomas.bravo@protonmail.ch";

    github = "tcbravo";
    githubId = 66133083;
  };
  tchab = {
    name = "t-chab";
    email = "dev@chabs.name";

    github = "t-chab";
    githubId = 2120966;
  };
  tchekda = {
    name = "David Tchekachev";
    email = "contact@tchekda.fr";

    github = "Tchekda";
    githubId = 23559888;
    keys = [{
      fingerprint = "44CE A8DD 3B31 49CD 6246  9D8F D0A0 07ED A4EA DA0F";
    }];
  };
  tckmn = {
    name = "Andy Tockman";
    email = "andy@tck.mn";

    github = "tckmn";
    githubId = 2389333;
  };
  techknowlogick = {
    name = "techknowlogick";
    email = "techknowlogick@gitea.io";

    github = "techknowlogick";
    githubId = 164197;
  };
  Technical27 = {
    name = "Aamaruvi Yogamani";
    email = "38222826+Technical27@users.noreply.github.com";

    github = "Technical27";
    githubId = 38222826;
  };
  teh = {
    name = "Tom Hunger";
    email = "tehunger@gmail.com";

    github = "teh";
    githubId = 139251;
  };
  tejasag = {
    name = "Tejas Agarwal";
    email = "tejasagarwalbly@gmail.com";

    github = "tejasag";
    githubId = 67542663;
  };
  telotortium = {
    name = "Robert Irelan";
    email = "rirelan@gmail.com";

    github = "telotortium";
    githubId = 1755789;
  };
  teozkr = {
    name = "Teo Klestrup Röijezon";
    email = "teo@nullable.se";

    github = "teozkr";
    githubId = 649832;
  };
  terin = {
    name = "Terin Stock";
    email = "terinjokes@gmail.com";

    github = "terinjokes";
    githubId = 273509;
  };
  terlar = {
    name = "Terje Larsen";
    email = "terlar@gmail.com";

    github = "terlar";
    githubId = 280235;
  };
  terrorjack = {
    name = "Cheng Shao";
    email = "astrohavoc@gmail.com";

    github = "TerrorJack";
    githubId = 3889585;
  };
  tesq0 = {
    name = "Mikolaj Galkowski";
    email = "mikolaj.galkowski@gmail.com";

    github = "tesq0";
    githubId = 26417242;
  };
  TethysSvensson = {
    name = "Tethys Svensson";
    email = "freaken@freaken.dk";

    github = "TethysSvensson";
    githubId = 4294434;
  };
  teto = {
    name = "Matthieu Coudron";
    email = "mcoudron@hotmail.com";

    github = "teto";
    githubId = 886074;
  };
  teutat3s = {
    name = "teutat3s";
    email = "teutates@mailbox.org";

    matrix = "@teutat3s:pub.solar";
    github = "teutat3s";
    githubId = 10206665;
    keys = [{
      fingerprint = "81A1 1C61 F413 8C84 9139  A4FA 18DA E600 A6BB E705";
    }];
  };
  tex = {
    name = "Milan Svoboda";
    email = "milan.svoboda@centrum.cz";

    github = "tex";
    githubId = 27386;
  };
  tfc = {
    name = "Jacek Galowicz";
    email = "jacek@galowicz.de";

    matrix = "@jonge:ukvly.org";
    github = "tfc";
    githubId = 29044;
  };
  tfmoraes = {
    name = "Thiago Franco de Moraes";
    email = "351108+tfmoraes@users.noreply.github.com";

    github = "tfmoraes";
    githubId = 351108;
  };
  tg-x = {
    name = "TG ⊗ Θ";
    email = "*@tg-x.net";

    github = "tg-x";
    githubId = 378734;
  };
  tgunnoe = {
    name = "Taylor Gunnoe";
    email = "t@gvno.net";

    github = "tgunnoe";
    githubId = 7254833;
  };
  th0rgal = {
    name = "Thomas Marchand";
    email = "thomas.marchand@tuta.io";

    github = "Th0rgal";
    githubId = 41830259;
  };
  thall = {
    name = "Niclas Thall";
    email = "niclas.thall@gmail.com";

    github = "thall";
    githubId = 102452;
  };
  thammers = {
    name = "Tobias Hammerschmidt";
    email = "jawr@gmx.de";

    github = "tobias-hammerschmidt";
    githubId = 2543259;
  };
  thanegill = {
    name = "Thane Gill";
    email = "me@thanegill.com";

    github = "thanegill";
    githubId = 1141680;
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
    name = "John Smith";
    email = "esthromeris@riseup.net";

    github = "TheBrainScrambler";
    githubId = 34945377;
  };
  thedavidmeister = {
    name = "David Meister";
    email = "thedavidmeister@gmail.com";

    github = "thedavidmeister";
    githubId = 629710;
  };
  thefenriswolf = {
    name = "Stefan Rohrbacher";
    email = "stefan.rohrbacher97@gmail.com";

    github = "thefenriswolf";
    githubId = 8547242;
  };
  thefloweringash = {
    name = "Andrew Childs";
    email = "lorne@cons.org.nz";

    github = "thefloweringash";
    githubId = 42933;
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
    name = "Jan Beinke";
    email = "mail+nixos@0jb.de";

    github = "thelegy";
    githubId = 3105057;
  };
  thenonameguy = {
    name = "Krisztian Szabo";
    email = "thenonameguy24@gmail.com";

    github = "thenonameguy";
    githubId = 2217181;
  };
  therealansh = {
    name = "Ansh Tyagi";
    email = "tyagiansh23@gmail.com";

    github = "therealansh";
    githubId = 57180880;
  };
  therishidesai = {
    name = "Rishi Desai";
    email = "desai.rishi1@gmail.com";

    github = "therishidesai";
    githubId = 5409166;
  };
  thesola10 = {
    name = "Karim Vergnes";
    email = "me@thesola.io";

    github = "Thesola10";
    githubId = 7287268;
    keys = [{
      fingerprint = "1D05 13A6 1AC4 0D8D C6D6  5F2C 8924 5619 BEBB 95BA";
    }];
  };
  thetallestjj = {
    name = "Jeroen Jetten";
    email = "me+nixpkgs@jeroen-jetten.com";

    github = "TheTallestJJ";
    githubId = 6579555;
  };
  theuni = {
    name = "Christian Theune";
    email = "ct@flyingcircus.io";

    github = "ctheune";
    githubId = 1220572;
  };
  thiagokokada = {
    name = "Thiago K. Okada";
    email = "thiagokokada@gmail.com";

    matrix = "@k0kada:matrix.org";
    github = "thiagokokada";
    githubId = 844343;
  };
  thibaultlemaire = {
    name = "Thibault Lemaire";
    email = "thibault.lemaire@protonmail.com";

    github = "ThibaultLemaire";
    githubId = 21345269;
  };
  thibautmarty = {
    name = "Thibaut Marty";
    email = "github@thibautmarty.fr";

    matrix = "@thibaut:thibautmarty.fr";
    github = "ThibautMarty";
    githubId = 3268082;
  };
  thmzlt = {
    name = "Thomaz Leite";
    email = "git@thomazleite.com";

    github = "thmzlt";
    githubId = 7709;
  };
  thomasdesr = {
    name = "Thomas Desrosiers";
    email = "git@hive.pw";

    github = "thomasdesr";
    githubId = 681004;
  };
  thomasjm = {
    name = "Tom McLaughlin";
    email = "tom@codedown.io";

    github = "thomasjm";
    githubId = 1634990;
  };
  ThomasMader = {
    name = "Thomas Mader";
    email = "thomas.mader@gmail.com";

    github = "ThomasMader";
    githubId = 678511;
  };
  thoughtpolice = {
    name = "Austin Seipp";
    email = "aseipp@pobox.com";

    github = "thoughtpolice";
    githubId = 3416;
  };
  thpham = {
    name = "Thomas Pham";
    email = "thomas.pham@ithings.ch";

    github = "thpham";
    githubId = 224674;
  };
  Thra11 = {
    name = "Tom Hall";
    email = "tahall256@protonmail.ch";

    github = "Thra11";
    githubId = 1391883;
  };
  Thunderbottom = {
    name = "Chinmay D. Pai";
    email = "chinmaydpai@gmail.com";

    github = "Thunderbottom";
    githubId = 11243138;
    keys = [{
      fingerprint = "7F3E EEAA EE66 93CC 8782  042A 7550 7BE2 56F4 0CED";
    }];
  };
  thyol = {
    name = "thyol";
    email = "thyol@pm.me";

    github = "thyol";
    githubId = 81481634;
  };
  tiagolobocastro = {
    name = "Tiago Castro";
    email = "tiagolobocastro@gmail.com";

    github = "tiagolobocastro";
    githubId = 1618946;
  };
  tilcreator = {
    name = "TilCreator";
    email = "contact.nixos@tc-j.de";

    matrix = "@tilcreator:matrix.org";
    github = "TilCreator";
    githubId = 18621411;
  };
  tilpner = {
    name = "Till Höppner";
    email = "till@hoeppner.ws";

    github = "tilpner";
    githubId = 4322055;
  };
  timbertson = {
    name = "Tim Cuthbertson";
    email = "tim@gfxmonk.net";

    github = "timbertson";
    githubId = 14172;
  };
  timma = {
    name = "Timma";
    email = "kunduru.it.iitb@gmail.com";

    github = "ktrsoft";
    githubId = 12712927;
  };
  timokau = {
    name = "Timo Kaufmann";
    email = "timokau@zoho.com";

    github = "timokau";
    githubId = 3799330;
  };
  timor = {
    name = "timor";
    email = "timor.dd@googlemail.com";

    github = "timor";
    githubId = 174156;
  };
  timput = {
    name = "Tim Put";
    email = "tim@timput.com";

    github = "TimPut";
    githubId = 2845239;
  };
  timstott = {
    name = "Timothy Stott";
    email = "stott.timothy@gmail.com";

    github = "timstott";
    githubId = 1334474;
  };
  tiramiseb = {
    name = "Sébastien Maccagnoni";
    email = "sebastien@maccagnoni.eu";

    github = "tiramiseb";
    githubId = 1292007;
  };
  tirex = {
    name = "Szymon Kliniewski";
    email = "szymon@kliniewski.pl";

    github = "NoneTirex";
    githubId = 26038207;
  };
  titanous = {
    name = "Jonathan Rudenberg";
    email = "jonathan@titanous.com";

    github = "titanous";
    githubId = 13026;
  };
  tjni = {
    name = "Theodore Ni";
    email = "43ngvg@masqt.com";

    matrix = "@tni:matrix.org";
    github = "tjni";
    githubId = 3806110;
    keys = [{
      fingerprint = "4384 B8E1 299F C028 1641  7B8F EC30 EFBE FA7E 84A4";
    }];
  };
  tkerber = {
    name = "Thomas Kerber";
    email = "tk@drwx.org";

    github = "tkerber";
    githubId = 5722198;
    keys = [{
      fingerprint = "556A 403F B0A2 D423 F656  3424 8489 B911 F9ED 617B";
    }];
  };
  tljuniper = {
    name = "Anna Gillert";
    email = "tljuniper1@gmail.com";

    github = "tljuniper";
    githubId = 48209000;
  };
  tmarkovski = {
    name = "Tomislav Markovski";
    email = "tmarkovski@gmail.com";

    github = "tmarkovski";
    githubId = 1280118;
  };
  tmountain = {
    name = "Travis Whitton";
    email = "tinymountain@gmail.com";

    github = "tmountain";
    githubId = 135297;
  };
  tmplt = {
    name = "Viktor";
    email = "tmplt@dragons.rocks";

    github = "tmplt";
    githubId = 6118602;
  };
  tnias = {
    name = "Philipp Bartsch";
    email = "phil@grmr.de";

    matrix = "@tnias:stratum0.org";
    github = "tnias";
    githubId = 9853194;
  };
  toastal = {
    name = "toastal";
    email = "toastal+nix@posteo.net";

    matrix = "@toastal:matrix.org";
    github = "toastal";
    githubId = 561087;
    keys = [{
      fingerprint = "7944 74B7 D236 DAB9 C9EF  E7F9 5CCE 6F14 66D4 7C9E";
    }];
  };
  tobiasBora = {
    name = "Tobias Bora";
    email = "tobias.bora.list@gmail.com";

    github = "tobiasBora";
    githubId = 2164118;
  };
  tobim = {
    name = "Tobias Mayer";
    email = "nix@tobim.fastmail.fm";

    github = "tobim";
    githubId = 858790;
  };
  tokudan = {
    name = "Daniel Frank";
    email = "git@danielfrank.net";

    github = "tokudan";
    githubId = 692610;
  };
  tomahna = {
    name = "Kevin Rauscher";
    email = "kevin.rauscher@tomahna.fr";

    github = "Tomahna";
    githubId = 8577941;
  };
  tomberek = {
    name = "Thomas Bereknyei";
    email = "tomberek@gmail.com";

    matrix = "@tomberek:matrix.org";
    github = "tomberek";
    githubId = 178444;
  };
  tomfitzhenry = {
    name = "Tom Fitzhenry";
    email = "tom@tom-fitzhenry.me.uk";

    github = "tomfitzhenry";
    githubId = 61303;
  };
  tomhoule = {
    name = "Tom Houle";
    email = "secondary+nixpkgs@tomhoule.com";

    github = "tomhoule";
    githubId = 13155277;
  };
  tomodachi94 = {
    name = "Tomodachi94";
    email = "tomodachi94+nixpkgs@protonmail.com";

    matrix = "@tomodachi94:matrix.org";
    github = "tomodachi94";
    githubId = 68489118;
  };
  tomsiewert = {
    name = "Tom Siewert";
    email = "tom@siewert.io";

    matrix = "@tom:frickel.earth";
    github = "tomsiewert";
    githubId = 8794235;
  };
  tomsmeets = {
    name = "Tom Smeets";
    email = "tom.tsmeets@gmail.com";

    github = "TomSmeets";
    githubId = 6740669;
  };
  tonyshkurenko = {
    name = "Anton Shkurenko";
    email = "support@twingate.com";

    github = "tonyshkurenko";
    githubId = 8597964;
  };
  toonn = {
    name = "Toon Nolten";
    email = "nixpkgs@toonn.io";

    matrix = "@toonn:matrix.org";
    github = "toonn";
    githubId = 1486805;
  };
  toschmidt = {
    name = "Tobias Schmidt";
    email = "tobias.schmidt@in.tum.de";

    github = "toschmidt";
    githubId = 27586264;
  };
  totoroot = {
    name = "Matthias Thym";
    email = "git@thym.at";

    github = "totoroot";
    githubId = 39650930;
  };
  ToxicFrog = {
    name = "Rebecca (Bex) Kelly";
    email = "toxicfrog@ancilla.ca";

    github = "ToxicFrog";
    githubId = 90456;
  };
  tpw_rules = {
    name = "Thomas Watson";
    email = "twatson52@icloud.com";

    matrix = "@tpw_rules:matrix.org";
    github = "tpwrules";
    githubId = 208010;
  };
  travisbhartwell = {
    name = "Travis B. Hartwell";
    email = "nafai@travishartwell.net";

    github = "travisbhartwell";
    githubId = 10110;
  };
  travisdavis-ops = {
    name = "Travis Davis";
    email = "travisdavismedia@gmail.com";

    github = "TravisDavis-ops";
    githubId = 52011418;
  };
  TredwellGit = {
    name = "Tredwell";
    email = "tredwell@tutanota.com";

    github = "TredwellGit";
    githubId = 61860346;
  };
  treemo = {
    name = "Matthieu Chevrier";
    email = "matthieu.chevrier@treemo.fr";

    github = "treemo";
    githubId = 207457;
  };
  trepetti = {
    name = "Tom Repetti";
    email = "trepetti@cs.columbia.edu";

    github = "trepetti";
    githubId = 25440339;
  };
  trevorj = {
    name = "Trevor Joynson";
    email = "nix@trevor.joynson.io";

    github = "akatrevorjay";
    githubId = 1312290;
  };
  tricktron = {
    name = "Thibault Gagnaux";
    email = "tgagnaux@gmail.com";

    github = "tricktron";
    githubId = 16036882;
  };
  trino = {
    name = "Hubert Mühlhans";
    email = "muehlhans.hubert@ekodia.de";

    github = "hmuehlhans";
    githubId = 9870613;
  };
  trobert = {
    name = "Thibaut Robert";
    email = "thibaut.robert@gmail.com";

    github = "trobert";
    githubId = 504580;
  };
  troydm = {
    name = "Dmitry Geurkov";
    email = "d.geurkov@gmail.com";

    github = "troydm";
    githubId = 483735;
  };
  truh = {
    name = "Jakob Klepp";
    email = "jakob-nixos@truh.in";

    github = "truh";
    githubId = 1183303;
  };
  trundle = {
    name = "Andreas Stührk";
    email = "andy@hammerhartes.de";

    github = "Trundle";
    githubId = 332418;
  };
  tscholak = {
    name = "Torsten Scholak";
    email = "torsten.scholak@googlemail.com";

    github = "tscholak";
    githubId = 1568873;
  };
  tshaynik = {
    name = "tshaynik";
    email = "tshaynik@protonmail.com";

    github = "tshaynik";
    githubId = 15064765;
  };
  ttuegel = {
    name = "Thomas Tuegel";
    email = "ttuegel@mailbox.org";

    github = "ttuegel";
    githubId = 563054;
  };
  tu-maurice = {
    name = "Valentin Gehrke";
    email = "valentin.gehrke+nixpkgs@zom.bi";

    github = "tu-maurice";
    githubId = 16151097;
  };
  turbomack = {
    name = "Marek Fajkus";
    email = "marek.faj@gmail.com";

    github = "turboMaCk";
    githubId = 2130305;
  };
  turion = {
    name = "Manuel Bärenz";
    email = "programming@manuelbaerenz.de";

    github = "turion";
    githubId = 303489;
  };
  tuxinaut = {
    name = "Denny Schäfer";
    email = "trash4you@tuxinaut.de";

    github = "tuxinaut";
    githubId = 722482;
    keys = [{
      fingerprint = "C752 0E49 4D92 1740 D263  C467 B057 455D 1E56 7270";
    }];
  };
  tv = {
    name = "Tomislav Viljetić";
    email = "tv@krebsco.de";

    github = "4z3";
    githubId = 427872;
  };
  tvestelind = {
    name = "Tomas Vestelind";
    email = "tomas.vestelind@fripost.org";

    github = "tvestelind";
    githubId = 699403;
  };
  tviti = {
    name = "Taylor Viti";
    email = "tviti@hawaii.edu";

    github = "tviti";
    githubId = 2251912;
  };
  tvorog = {
    name = "Marsel Zaripov";
    email = "marszaripov@gmail.com";

    github = "TvoroG";
    githubId = 1325161;
  };
  tweber = {
    name = "Thorsten Weber";
    email = "tw+nixpkgs@360vier.de";

    github = "thorstenweber83";
    githubId = 9413924;
  };
  twey = {
    name = "James ‘Twey’ Kay";
    email = "twey@twey.co.uk";

    github = "Twey";
    githubId = 101639;
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
    name = "Tyler Langlois";
    email = "tyler+nixpkgs@langlois.to";

    matrix = "@ty:tjll.net";
    github = "tylerjl";
    githubId = 1733846;
  };
  typetetris = {
    name = "Eric Wolf";
    email = "ericwolf42@mail.com";

    github = "typetetris";
    githubId = 1983821;
  };
  uakci = {
    name = "uakci";
    email = "uakci@uakci.pl";

    github = "uakci";
    githubId = 6961268;
  };
  udono = {
    name = "Udo Spallek";
    email = "udono@virtual-things.biz";

    github = "udono";
    githubId = 347983;
  };
  ulrikstrid = {
    name = "Ulrik Strid";
    email = "ulrik.strid@outlook.com";

    github = "ulrikstrid";
    githubId = 1607770;
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
    name = "Kevin Brubeck Unhammer";
    email = "unhammer@fsfe.org";

    github = "unhammer";
    githubId = 56868;
    keys = [{
      fingerprint = "50D4 8796 0B86 3F05 4B6A  12F9 7426 06DE 766A C60C";
    }];
  };
  uniquepointer = {
    name = "uniquepointer";
    email = "uniquepointer@mailbox.org";

    matrix = "@uniquepointer:matrix.org";
    github = "uniquepointer";
    githubId = 71751817;
  };
  unode = {
    name = "Renato Alves";
    email = "alves.rjc@gmail.com";

    matrix = "@renato_alves:matrix.org";
    github = "unode";
    githubId = 122319;
  };
  unrooted = {
    name = "Konrad Klawikowski";
    email = "konrad.root.klawikowski@gmail.com";

    github = "unrooted";
    githubId = 30440603;
  };
  uralbash = {
    name = "Svintsov Dmitry";
    email = "root@uralbash.ru";

    github = "uralbash";
    githubId = 619015;
  };
  urandom = {
    name = "Colin Arnott";
    email = "colin@urandom.co.uk";

    matrix = "@urandom0:matrix.org";
    github = "urandom2";
    githubId = 2526260;
    keys = [{
      fingerprint = "04A3 A2C6 0042 784A AEA7  D051 0447 A663 F7F3 E236";
    }];
  };
  urbas = {
    name = "Matej Urbas";
    email = "matej.urbas@gmail.com";

    github = "urbas";
    githubId = 771193;
  };
  uri-canva = {
    name = "Uri Baghin";
    email = "uri@canva.com";

    github = "uri-canva";
    githubId = 33242106;
  };
  urlordjames = {
    name = "urlordjames";
    email = "urlordjames@gmail.com";

    github = "urlordjames";
    githubId = 32751441;
  };
  ursi = {
    name = "Mason Mackaman";
    email = "masondeanm@aol.com";

    github = "ursi";
    githubId = 17836748;
  };
  uskudnik = {
    name = "Urban Skudnik";
    email = "urban.skudnik@gmail.com";

    github = "uskudnik";
    githubId = 120451;
  };
  usrfriendly = {
    name = "Arin Lares";
    email = "arinlares@gmail.com";

    github = "usrfriendly";
    githubId = 2502060;
  };
  utdemir = {
    name = "Utku Demir";
    email = "me@utdemir.com";

    github = "utdemir";
    githubId = 928084;
  };
  uthar = {
    name = "Kasper Gałkowski";
    email = "galkowskikasper@gmail.com";

    github = "uthar";
    githubId = 15697697;
  };
  uvnikita = {
    name = "Nikita Uvarov";
    email = "uv.nikita@gmail.com";

    github = "uvNikita";
    githubId = 1084748;
  };
  uwap = {
    name = "uwap";
    email = "me@uwap.name";

    github = "uwap";
    githubId = 2212422;
  };
  V = {
    name = "V";
    email = "v@anomalous.eu";

    github = "deviant";
    githubId = 68829907;
  };
  vaibhavsagar = {
    name = "Vaibhav Sagar";
    email = "vaibhavsagar@gmail.com";

    matrix = "@vaibhavsagar:matrix.org";
    github = "vaibhavsagar";
    githubId = 1525767;
  };
  valebes = {
    name = "Valerio Besozzi";
    email = "valebes@gmail.com";

    github = "valebes";
    githubId = 10956211;
  };
  valeriangalliat = {
    name = "Valérian Galliat";
    email = "val@codejam.info";

    github = "valeriangalliat";
    githubId = 3929133;
  };
  valodim = {
    name = "Vincent Breitmoser";
    email = "look@my.amazin.horse";

    matrix = "@Valodim:stratum0.org";
    github = "Valodim";
    githubId = 27813;
  };
  vandenoever = {
    name = "Jos van den Oever";
    email = "jos@vandenoever.info";

    github = "vandenoever";
    githubId = 608417;
  };
  vanilla = {
    name = "Vanilla";
    email = "osu_vanilla@126.com";

    github = "VergeDX";
    githubId = 25173827;
    keys = [{
      fingerprint = "2649 340C C909 F821 D251  6714 3750 028E D04F A42E";
    }];
  };
  vanschelven = {
    name = "Klaas van Schelven";
    email = "klaas@vanschelven.com";

    github = "vanschelven";
    githubId = 223833;
  };
  vanzef = {
    name = "Ivan Solyankin";
    email = "vanzef@gmail.com";

    github = "vanzef";
    githubId = 12428837;
  };
  varunpatro = {
    name = "Varun Patro";
    email = "varun.kumar.patro@gmail.com";

    github = "varunpatro";
    githubId = 6943308;
  };
  vbgl = {
    name = "Vincent Laporte";
    email = "Vincent.Laporte@gmail.com";

    github = "vbgl";
    githubId = 2612464;
  };
  vbmithr = {
    name = "Vincent Bernardoff";
    email = "vb@luminar.eu.org";

    github = "vbmithr";
    githubId = 797581;
  };
  vbrandl = {
    name = "Valentin Brandl";
    email = "mail+nixpkgs@vbrandl.net";

    github = "vbrandl";
    githubId = 20639051;
  };
  vcanadi = {
    name = "Vitomir Čanadi";
    email = "vito.canadi@gmail.com";

    github = "vcanadi";
    githubId = 8889722;
  };
  vcunat = {
    name = "Vladimír Čunát";
    email = "v@cunat.cz";

    matrix = "@vcunat:matrix.org";
    github = "vcunat";
    githubId = 1785925;
    keys = [{
      fingerprint = "B600 6460 B60A 80E7 8206  2449 E747 DF1F 9575 A3AA";
    }];
  };
  vdemeester = {
    name = "Vincent Demeester";
    email = "vincent@sbr.pm";

    github = "vdemeester";
    githubId = 6508;
  };
  vdot0x23 = {
    name = "Victor Büttner";
    email = "nix.victor@0x23.dk";

    github = "vdot0x23";
    githubId = 40716069;
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
    name = "vel";
    email = "llathasa@outlook.com";

    github = "q60";
    githubId = 61933599;
  };
  velovix = {
    name = "Tyler Compton";
    email = "xaviosx@gmail.com";

    github = "velovix";
    githubId = 2856634;
  };
  veprbl = {
    name = "Dmitry Kalinkin";
    email = "veprbl@gmail.com";

    github = "veprbl";
    githubId = 245573;
  };
  victormignot = {
    name = "Victor Mignot";
    email = "root@victormignot.fr";

    github = "victormignot";
    githubId = 58660971;
    keys = [{
      fingerprint = "CA5D F91A D672 683A 1F65  BBC9 0317 096D 20E0 067B";
    }];
  };
  vidbina = {
    name = "David Asabina";
    email = "vid@bina.me";

    github = "vidbina";
    githubId = 335406;
  };
  vidister = {
    name = "Fiona Weber";
    email = "v@vidister.de";

    github = "vidister";
    githubId = 11413574;
  };
  vifino = {
    name = "Adrian Pistol";
    email = "vifino@tty.sh";

    github = "vifino";
    githubId = 5837359;
  };
  vikanezrimaya = {
    name = "Vika Shleina";
    email = "vika@fireburn.ru";

    github = "vikanezrimaya";
    githubId = 7953163;
    keys = [{
      fingerprint = "B3C0 DA1A C18B 82E8 CA8B  B1D1 4F62 CD07 CE64 796A";
    }];
  };
  vincentbernat = {
    name = "Vincent Bernat";
    email = "vincent@bernat.ch";

    github = "vincentbernat";
    githubId = 631446;
    keys = [{
      fingerprint = "AEF2 3487 66F3 71C6 89A7  3600 95A4 2FE8 3535 25F9";
    }];
  };
  vinymeuh = {
    name = "VinyMeuh";
    email = "vinymeuh@gmail.com";

    github = "vinymeuh";
    githubId = 118959;
  };
  viraptor = {
    name = "Stanisław Pitucha";
    email = "nix@viraptor.info";

    github = "viraptor";
    githubId = 188063;
  };
  virchau13 = {
    name = "Vir Chaudhury";
    email = "virchau13@hexular.net";

    github = "virchau13";
    githubId = 16955157;
  };
  viric = {
    name = "Lluís Batlle i Rossell";
    email = "viric@viric.name";

    github = "viric";
    githubId = 66664;
  };
  virusdave = {
    name = "Dave Nicponski";
    email = "dave.nicponski@gmail.com";

    github = "virusdave";
    githubId = 6148271;
  };
  vizanto = {
    name = "Danny Wilson";
    email = "danny@prime.vc";

    github = "vizanto";
    githubId = 326263;
  };
  vklquevs = {
    name = "vklquevs";
    email = "vklquevs@gmail.com";

    github = "vklquevs";
    githubId = 1771234;
  };
  vlaci = {
    name = "László Vaskó";
    email = "laszlo.vasko@outlook.com";

    github = "vlaci";
    githubId = 1771332;
  };
  vlinkz = {
    name = "Victor Fuentes";
    email = "vmfuentes64@gmail.com";

    github = "vlinkz";
    githubId = 20145996;
  };
  vlstill = {
    name = "Vladimír Štill";
    email = "xstill@fi.muni.cz";

    github = "vlstill";
    githubId = 4070422;
  };
  vmandela = {
    name = "Venkateswara Rao Mandela";
    email = "venkat.mandela@gmail.com";

    github = "vmandela";
    githubId = 849772;
  };
  vmchale = {
    name = "Vanessa McHale";
    email = "tmchale@wisc.edu";

    github = "vmchale";
    githubId = 13259982;
  };
  voidless = {
    name = "Julius Schmitt";
    email = "julius.schmitt@yahoo.de";

    github = "voidIess";
    githubId = 45292658;
  };
  vojta001 = {
    name = "Vojta Káně";
    email = "vojtech.kane@gmail.com";

    github = "vojta001";
    githubId = 7038383;
  };
  volhovm = {
    name = "Mikhail Volkhov";
    email = "volhovm.cs@gmail.com";

    github = "volhovm";
    githubId = 5604643;
  };
  vonfry = {
    name = "Vonfry";
    email = "nixos@vonfry.name";

    github = "Vonfry";
    githubId = 3413119;
  };
  vq = {
    name = "Daniel Nilsson";
    email = "vq@erq.se";

    github = "vq";
    githubId = 230381;
  };
  vrinek = {
    name = "Kostas Karachalios";
    email = "vrinek@hey.com";

    github = "vrinek";
    githubId = 81346;
  };
  vrthra = {
    name = "Rahul Gopinath";
    email = "rahul@gopinath.org";

    github = "vrthra";
    githubId = 70410;
  };
  vskilet = {
    name = "Victor SENE";
    email = "victor@sene.ovh";

    github = "Vskilet";
    githubId = 7677567;
  };
  vtuan10 = {
    name = "Van Tuan Vo";
    email = "mail@tuan-vo.de";

    github = "vtuan10";
    githubId = 16415673;
  };
  vyorkin = {
    name = "Vasiliy Yorkin";
    email = "vasiliy.yorkin@gmail.com";

    github = "vyorkin";
    githubId = 988849;
  };
  vyp = {
    name = "vyp";
    email = "elisp.vim@gmail.com";

    github = "vyp";
    githubId = 3889405;
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
  waelwindows = {
    name = "waelwindows";
    email = "waelwindows9922@gmail.com";

    github = "Waelwindows";
    githubId = 5228243;
  };
  waiting-for-dev = {
    name = "Marc Busqué";
    email = "marc@lamarciana.com";

    github = "waiting-for-dev";
    githubId = 52650;
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
    name = "Varun Narravula";
    email = "varun@cvte.org";

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
    name = "wchresta";
    email = "wchresta.nix@chrummibei.ch";

    github = "wchresta";
    githubId = 34962284;
  };
  wd15 = {
    name = "Daniel Wheeler";
    email = "daniel.wheeler2@gmail.com";

    github = "wd15";
    githubId = 1986844;
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
    name = "Weihua Lu";
    email = "luwh364@gmail.com";

    github = "weihua-lu";
    githubId = 9002575;
  };
  welteki = {
    name = "Han Verstraete";
    email = "welteki@pm.me";

    github = "welteki";
    githubId = 16267532;
    keys = [{
      fingerprint = "2145 955E 3F5E 0C95 3458  41B5 11F7 BAEA 8567 43FF";
    }];
  };
  wenngle = {
    name = "Zeke Stephens";
    email = "zekestephens@gmail.com";

    github = "wenngle";
    githubId = 63376671;
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
  wesleyjrz = {
    name = "Wesley V. Santos Jr.";
    email = "dev@wesleyjrz.com";

    github = "wesleyjrz";
    githubId = 60184588;
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
    name = "Jakob Schmutz";
    email = "jakob@schmutz.co.uk";

    github = "wheelsandmetal";
    githubId = 13031455;
  };
  WhittlesJr = {
    name = "Alex Whitt";
    email = "alex.joseph.whitt@gmail.com";

    github = "WhittlesJr";
    githubId = 19174984;
  };
  whonore = {
    name = "Wolf Honoré";
    email = "wolfhonore@gmail.com";

    github = "whonore";
    githubId = 7121530;
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
  willcohen = {
    name = "Will Cohen";
    email = "willcohen@users.noreply.github.com";

    github = "willcohen";
    githubId = 5185341;
  };
  willibutz = {
    name = "Willi Butz";
    email = "willibutz@posteo.de";

    github = "WilliButz";
    githubId = 20464732;
  };
  wilsonehusin = {
    name = "Wilson E. Husin";
    email = "wilsonehusin@gmail.com";

    github = "wilsonehusin";
    githubId = 14004487;
  };
  winpat = {
    name = "Patrick Winter";
    email = "patrickwinter@posteo.ch";

    github = "winpat";
    githubId = 6016963;
  };
  winter = {
    name = "Winter";
    email = "nixos@winter.cafe";

    github = "winterqt";
    githubId = 78392041;
  };
  wintrmvte = {
    name = "Jakub Lutczyn";
    email = "kubalutczyn@gmail.com";

    github = "wintrmvte";
    githubId = 41823252;
  };
  wirew0rm = {
    name = "Alexander Krimm";
    email = "alex@wirew0rm.de";

    github = "wirew0rm";
    githubId = 1202371;
  };
  wishfort36 = {
    name = "wishfort36";
    email = "42300264+wishfort36@users.noreply.github.com";

    github = "wishfort36";
    githubId = 42300264;
  };
  wizeman = {
    name = "Ricardo M. Correia";
    email = "rcorreia@wizy.org";

    github = "wizeman";
    githubId = 168610;
  };
  wjlroe = {
    name = "William Roe";
    email = "willroe@gmail.com";

    github = "wjlroe";
    githubId = 43315;
  };
  wldhx = {
    name = "wldhx";
    email = "wldhx+nixpkgs@wldhx.me";

    github = "wldhx";
    githubId = 15619766;
  };
  wmertens = {
    name = "Wout Mertens";
    email = "Wout.Mertens@gmail.com";

    github = "wmertens";
    githubId = 54934;
  };
  wnklmnn = {
    name = "Pascal Winkelmann";
    email = "pascal@wnklmnn.de";

    github = "wnklmnn";
    githubId = 9423014;
  };
  woffs = {
    name = "Frank Doepper";
    email = "github@woffs.de";

    github = "woffs";
    githubId = 895853;
  };
  wohanley = {
    name = "William O'Hanley";
    email = "me@wohanley.com";

    github = "wohanley";
    githubId = 1322287;
  };
  woky = {
    name = "Andrei Pampu";
    email = "pampu.andrei@pm.me";

    github = "andreisergiu98";
    githubId = 11740700;
  };
  wolfangaukang = {
    name = "P. R. d. O.";
    email = "clone.gleeful135+nixpkgs@anonaddy.me";

    github = "WolfangAukang";
    githubId = 8378365;
  };
  womfoo = {
    name = "Kranium Gikos Mendoza";
    email = "kranium@gikos.net";

    github = "womfoo";
    githubId = 1595132;
  };
  worldofpeace = {
    name = "WORLDofPEACE";
    email = "worldofpeace@protonmail.ch";

    github = "worldofpeace";
    githubId = 28888242;
  };
  wozeparrot = {
    name = "Woze Parrot";
    email = "wozeparrot@gmail.com";

    github = "wozeparrot";
    githubId = 25372613;
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
    name = "Wayne Scott";
    email = "wsc9tt@gmail.com";

    github = "wscott";
    githubId = 31487;
  };
  wucke13 = {
    name = "Wucke";
    email = "wucke13@gmail.com";

    github = "wucke13";
    githubId = 20400405;
  };
  wulfsta = {
    name = "Wulfsta";
    email = "wulfstawulfsta@gmail.com";

    github = "Wulfsta";
    githubId = 13378502;
  };
  wunderbrick = {
    name = "Andrew Phipps";
    email = "lambdafuzz@tutanota.com";

    github = "wunderbrick";
    githubId = 52174714;
  };
  wuyoli = {
    name = "wuyoli";
    email = "wuyoli@tilde.team";

    github = "wuyoli";
    githubId = 104238274;
  };
  wykurz = {
    name = "Mateusz Wykurz";
    email = "wykurz@gmail.com";

    github = "wykurz";
    githubId = 483465;
  };
  wyndon = {
    name = "wyndon";
    email = "72203260+wyndon@users.noreply.github.com";

    matrix = "@wyndon:envs.net";
    github = "wyndon";
    githubId = 72203260;
  };
  wyvie = {
    name = "Elijah Rum";
    email = "elijahrum@gmail.com";

    github = "alicerum";
    githubId = 3992240;
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
    name = "Dominik Xaver Hörl";
    email = "hoe.dom@gmx.de";

    github = "xaverdh";
    githubId = 11050617;
  };
  xavierzwirtz = {
    name = "Xavier Zwirtz";
    email = "me@xavierzwirtz.com";

    github = "xavierzwirtz";
    githubId = 474343;
  };
  xbreak = {
    name = "Calle Rosenquist";
    email = "xbreak@alphaware.se";

    github = "xbreak";
    githubId = 13489144;
  };
  xdhampus = {
    name = "Hampus";
    email = "16954508+xdHampus@users.noreply.github.com";

    github = "xdHampus";
    githubId = 16954508;
  };
  xe = {
    name = "Christine Dodrill";
    email = "me@christine.website";

    matrix = "@withoutwithin:matrix.org";
    github = "Xe";
    githubId = 529003;
  };
  xeji = {
    name = "Uli Baum";
    email = "xeji@cat3.de";

    github = "xeji";
    githubId = 36407913;
  };
  xfix = {
    name = "Konrad Borowski";
    email = "konrad@borowski.pw";

    matrix = "@xfix:matrix.org";
    github = "xfix";
    githubId = 1297598;
  };
  xfnw = {
    name = "Owen";
    email = "xfnw+nixos@riseup.net";

    github = "xfnw";
    githubId = 66233223;
  };
  xgroleau = {
    name = "Xavier Groleau";
    email = "xgroleau@gmail.com";

    github = "xgroleau";
    githubId = 31734358;
  };
  xiorcale = {
    name = "Quentin Vaucher";
    email = "quentin.vaucher@pm.me";

    github = "xiorcale";
    githubId = 17534323;
  };
  xnaveira = {
    name = "Xavier Naveira";
    email = "xnaveira@gmail.com";

    github = "xnaveira";
    githubId = 2534411;
  };
  xnwdd = {
    name = "Guillermo NWDD";
    email = "nwdd+nixos@no.team";

    github = "xNWDD";
    githubId = 3028542;
  };
  xrelkd = {
    name = "xrelkd";
    email = "46590321+xrelkd@users.noreply.github.com";

    github = "xrelkd";
    githubId = 46590321;
  };
  xurei = {
    name = "Olivier Bourdoux";
    email = "olivier.bourdoux@gmail.com";

    github = "xurei";
    githubId = 621695;
  };
  xvapx = {
    name = "Marti Serra";
    email = "marti.serra.coscollano@gmail.com";

    github = "xvapx";
    githubId = 11824817;
  };
  xworld21 = {
    name = "Vincenzo Mantova";
    email = "1962985+xworld21@users.noreply.github.com";

    github = "xworld21";
    githubId = 1962985;
  };
  xyenon = {
    name = "XYenon";
    email = "i@xyenon.bid";

    github = "XYenon";
    githubId = 20698483;
  };
  xzfc = {
    name = "Albert Safin";
    email = "xzfcpw@gmail.com";

    github = "xzfc";
    githubId = 5121426;
  };
  y0no = {
    name = "Yoann Ono";
    email = "y0no@y0no.fr";

    github = "y0no";
    githubId = 2242427;
  };
  yana = {
    name = "Yana Timoshenko";
    email = "yana@riseup.net";

    github = "yanalunaterra";
    githubId = 1643293;
  };
  yanganto = {
    name = "Antonio Yang";
    email = "yanganto@gmail.com";

    github = "yanganto";
    githubId = 10803111;
  };
  yarny = {
    name = "Yarny";
    email = "41838844+Yarny0@users.noreply.github.com";

    github = "Yarny0";
    githubId = 41838844;
  };
  yarr = {
    name = "Dmitry V.";
    email = "savraz@gmail.com";

    github = "Eternity-Yarr";
    githubId = 3705333;
  };
  yayayayaka = {
    name = "Lara A.";
    email = "nixpkgs@uwu.is";

    matrix = "@lara:uwu.is";
    github = "yayayayaka";
    githubId = 73759599;
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
  yesbox = {
    name = "Jesper Geertsen Jonsson";
    email = "jesper.geertsen.jonsson@gmail.com";

    github = "yesbox";
    githubId = 4113027;
  };
  yinfeng = {
    name = "Lin Yinfeng";
    email = "lin.yinfeng@outlook.com";

    github = "linyinfeng";
    githubId = 11229748;
  };
  yisuidenghua = {
    name = "Milena Yisui";
    email = "bileiner@gmail.com";

    github = "YisuiDenghua";
    githubId = 102890144;
  };
  yl3dy = {
    name = "Alexander Kiselyov";
    email = "aleksandr.kiselyov@gmail.com";

    github = "yl3dy";
    githubId = 1311192;
  };
  ylecornec = {
    name = "Yves-Stan Le Cornec";
    email = "yves.stan.lecornec@tweag.io";

    github = "ylecornec";
    githubId = 5978566;
  };
  ylh = {
    name = "Yestin L. Harrison";
    email = "nixpkgs@ylh.io";

    github = "ylh";
    githubId = 9125590;
  };
  ylwghst = {
    name = "Burim Augustin Berisa";
    email = "ylwghst@onionmail.info";

    github = "ylwghst";
    githubId = 26011724;
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
  yochai = {
    name = "Yochai";
    email = "yochai@titat.info";

    github = "yochai";
    githubId = 1322201;
  };
  yoctocell = {
    name = "Yoctocell";
    email = "public@yoctocell.xyz";

    github = "yoctocell";
    githubId = 40352765;
  };
  yorickvp = {
    name = "Yorick van Pelt";
    email = "yorickvanpelt@gmail.com";

    matrix = "@yorickvp:matrix.org";
    github = "yorickvP";
    githubId = 647076;
  };
  yrashk = {
    name = "Yurii Rashkovskii";
    email = "yrashk@gmail.com";

    github = "yrashk";
    githubId = 452;
  };
  yrd = {
    name = "Yannik Rödel";
    email = "nix@yannik.info";

    github = "yrd";
    githubId = 1820447;
  };
  yshym = {
    name = "Yevhen Shymotiuk";
    email = "yshym@pm.me";

    github = "yshym";
    githubId = 44244245;
  };
  ysndr = {
    name = "Yannik Sander";
    email = "me@ysndr.de";

    github = "ysndr";
    githubId = 7040031;
  };
  yuka = {
    name = "Yureka";
    email = "yuka@yuka.dev";

    matrix = "@yuka:yuka.dev";
    github = "yu-re-ka";
    githubId = 86169957;
  };
  Yumasi = {
    name = "Guillaume Pagnoux";
    email = "gpagnoux@gmail.com";

    github = "Yumasi";
    githubId = 24368641;
    keys = [{
      fingerprint = "85F8 E850 F8F2 F823 F934  535B EC50 6589 9AEA AF4C";
    }];
  };
  yureien = {
    name = "Soham Sen";
    email = "contact@sohamsen.me";

    github = "Yureien";
    githubId = 17357089;
  };
  yuriaisaka = {
    name = "Yuri Aisaka";
    email = "yuri.aisaka+nix@gmail.com";

    github = "yuriaisaka";
    githubId = 687198;
  };
  yurkobb = {
    name = "Yury Bulka";
    email = "setthemfree@privacyrequired.com";

    github = "yurkobb";
    githubId = 479389;
  };
  yurrriq = {
    name = "Eric Bailey";
    email = "eric@ericb.me";

    github = "yurrriq";
    githubId = 1866448;
  };
  yusdacra = {
    name = "Yusuf Bera Ertan";
    email = "y.bera003.06@protonmail.com";

    matrix = "@yusdacra:nixos.dev";
    github = "yusdacra";
    githubId = 19897088;
    keys = [{
      fingerprint = "9270 66BD 8125 A45B 4AC4 0326 6180 7181 F60E FCB2";
    }];
  };
  yuu = {
    name = "Yuu Yin";
    email = "yuuyin@protonmail.com";

    github = "yuuyins";
    githubId = 86538850;
    keys = [{
      fingerprint = "9F19 3AE8 AA25 647F FC31  46B5 416F 303B 43C2 0AC3";
    }];
  };
  yvesf = {
    name = "Yves Fischer";
    email = "yvesf+nix@xapek.org";

    github = "yvesf";
    githubId = 179548;
  };
  yvt = {
    name = "yvt";
    email = "i@yvt.jp";

    github = "yvt";
    githubId = 5253988;
  };
  zachcoyle = {
    name = "Zach Coyle";
    email = "zach.coyle@gmail.com";

    github = "zachcoyle";
    githubId = 908716;
  };
  zagy = {
    name = "Christian Zagrodnick";
    email = "cz@flyingcircus.io";

    github = "zagy";
    githubId = 568532;
  };
  zakame = {
    name = "Zak B. Elep";
    email = "zakame@zakame.net";

    github = "zakame";
    githubId = 110625;
  };
  zakkor = {
    name = "Edward d'Albon";
    email = "edward.dalbon@gmail.com";

    github = "zakkor";
    githubId = 6191421;
  };
  zalakain = {
    name = "Uma Zalakain";
    email = "ping@umazalakain.info";

    github = "umazalakain";
    githubId = 1319905;
  };
  zanculmarktum = {
    name = "Azure Zanculmarktum";
    email = "zanculmarktum@gmail.com";

    github = "zanculmarktum";
    githubId = 16958511;
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
  zaninime = {
    name = "Francesco Zanini";
    email = "francesco@zanini.me";

    github = "zaninime";
    githubId = 450885;
  };
  zarelit = {
    name = "David Costa";
    email = "david@zarel.net";

    github = "zarelit";
    githubId = 3449926;
  };
  zauberpony = {
    name = "Elmar Athmer";
    email = "elmar@athmer.org";

    github = "elmarx";
    githubId = 250877;
  };
  zbioe = {
    name = "Iury Fukuda";
    email = "zbioe@protonmail.com";

    github = "zbioe";
    githubId = 7332055;
  };
  zebreus = {
    name = "Lennart Eichhorn";
    email = "lennarteichhorn+nixpkgs@gmail.com";

    matrix = "@lennart:cicen.net";
    github = "Zebreus";
    githubId = 1557253;
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
  zeratax = {
    name = "Jona Abdinghoff";
    email = "mail@zera.tax";

    github = "zeratax";
    githubId = 5024958;
    keys = [{
      fingerprint = "44F7 B797 9D3A 27B1 89E0  841E 8333 735E 784D F9D4";
    }];
  };
  zeri = {
    name = "zeri";
    email = "68825133+zeri42@users.noreply.github.com";

    matrix = "@zeri:matrix.org";
    github = "zeri42";
    githubId = 68825133;
  };
  zfnmxt = {
    name = "zfnmxt";
    email = "zfnmxt@zfnmxt.com";

    github = "zfnmxt";
    githubId = 37446532;
  };
  zgrannan = {
    name = "Zack Grannan";
    email = "zgrannan@gmail.com";

    github = "zgrannan";
    githubId = 1141948;
  };
  zhaofengli = {
    name = "Zhaofeng Li";
    email = "hello@zhaofeng.li";

    matrix = "@zhaofeng:zhaofeng.li";
    github = "zhaofengli";
    githubId = 2189609;
  };
  ziguana = {
    name = "Zig Uana";
    email = "git@ziguana.dev";

    github = "ziguana";
    githubId = 45833444;
  };
  zimbatm = {
    name = "zimbatm";
    email = "zimbatm@zimbatm.com";

    github = "zimbatm";
    githubId = 3248;
  };
  Zimmi48 = {
    name = "Théo Zimmermann";
    email = "theo.zimmermann@univ-paris-diderot.fr";

    github = "Zimmi48";
    githubId = 1108325;
  };
  zoedsoupe = {
    name = "Zoey de Souza Pessanha";
    email = "zoey.spessanha@outlook.com";

    github = "zoedsoupe";
    githubId = 44469426;
    keys = [{
      fingerprint = "EAA1 51DB 472B 0122 109A  CB17 1E1E 889C DBD6 A315";
    }];
  };
  zohl = {
    name = "Al Zohali";
    email = "zohl@fmap.me";

    github = "zohl";
    githubId = 6067895;
  };
  zokrezyl = {
    name = "Zokre Zyl";
    email = "zokrezyl@gmail.com";

    github = "zokrezyl";
    githubId = 51886259;
  };
  zombiezen = {
    name = "Ross Light";
    email = "ross@zombiezen.com";

    github = "zombiezen";
    githubId = 181535;
  };
  zookatron = {
    name = "Tim Zook";
    email = "tim@zookatron.com";

    github = "zookatron";
    githubId = 1772064;
  };
  zopieux = {
    name = "Alexandre Macabies";
    email = "zopieux@gmail.com";

    github = "zopieux";
    githubId = 81353;
  };
  zowoq = {
    name = "zowoq";
    email = "59103226+zowoq@users.noreply.github.com";

    github = "zowoq";
    githubId = 59103226;
  };
  zraexy = {
    name = "David Mell";
    email = "zraexy@gmail.com";

    github = "zraexy";
    githubId = 8100652;
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
  ztzg = {
    name = "Damien Diederen";
    email = "dd@crosstwine.com";

    github = "ztzg";
    githubId = 393108;
  };
  zupo = {
    name = "Nejc Zupan";
    email = "nejczupan+nix@gmail.com";

    github = "zupo";
    githubId = 311580;
  };
  zuzuleinen = {
    name = "Andrei Boar";
    email = "andrey.boar@gmail.com";

    github = "zuzuleinen";
    githubId = 944919;
  };
  zx2c4 = {
    name = "Jason A. Donenfeld";
    email = "Jason@zx2c4.com";

    github = "zx2c4";
    githubId = 10643;
  };
  zyansheep = {
    name = "Zyansheep";
    email = "zyansheep@protonmail.com";

    github = "zyansheep";
    githubId = 20029431;
  };
  zzamboni = {
    name = "Diego Zamboni";
    email = "diego@zzamboni.org";

    github = "zzamboni";
    githubId = 32876;
  };
}
