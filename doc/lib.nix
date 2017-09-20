{ writeTextDir, lib }:
let
  rootDir = toString ./..;
  commitHash = lib.sources.commitIdFromGitRepo ./../.git;

  mkGithubLink = file: line:
    let
      filePath = lib.strings.removePrefix "${rootDir}/" file;
      rootUrl = "https://github.com/NixOS/nixpkgs/blob/";
      ghUrl = "${rootUrl}${commitHash}/${filePath}#L${toString line}";
    in "<link xlink:href=\"${ghUrl}\">${filePath}:${toString line}</link>";

  cleanId = lib.strings.replaceChars [ "'" ] [ "-prime" ];


  attrsOnly = attrset: lib.filterAttrs (k: v: builtins.isAttrs v) attrset;

  docbookFromDoc = { name, pos, libgroupname }: {
        # MUST match lib/doc.nix's mkDoc function signaturex
        description,
        examples ? [],
        params ? [],
        return ? null
      }:
    let
      exampleDocbook = if examples == [] then ""
      else let
        exampleInner = lib.strings.concatMapStrings ({title, body}:
        ''
        <para>
          <example>
            <title>${title}</title>
            <programlisting role="nix"><![CDATA[${body}]]></programlisting>
          </example>
        </para>

      '') examples;
      in ''
        <refsect1 role="examples">
        <title>Examples</title>
        ${exampleInner}
        </refsect1>
      '';

      type = if return == null then ""
        else lib.strings.concatMapStringsSep " -> "
          (param: if builtins.match ".*->.*" param.type == []
                  then "(${param.type})"
                  else param.type)
          (params ++ [return]);

      typeDocbook = if type == "" then ""
        else ''
        <literal>${type}</literal>
        '';

      paramsDocbook = if params == [] then ""
        else let
          paramDocbook = lib.concatMapStrings
            (param:
              let
                type = if param.type == ""
                  then ""
                  else " <type>${param.type}</type>";

              in ''
              <varlistentry>
                <term><parameter>${param.name}</parameter>${type}</term>
                <listitem>
                  <para>${param.description}</para>
                </listitem>
              </varlistentry>
            '')
            params;
        in ''
          <refsect1 role="parameters">
            <title>Parameters</title>
            <para>
              <variablelist>
                ${paramDocbook}
              </variablelist>
            </para>
          </refsect1>
        '';

      returnDocbook = if return == null then ""
        else let

        in ''
          <refsect1 role="returnvalues">
            <title>Return Values</title>
            <para>Type: <type>${return.type}</type></para>
            <para>
              ${return.description}
            </para>
          </refsect1>
        '';

    in ''
      <refentry xml:id="fn-${cleanId libgroupname}-${cleanId name}">
        <refnamediv>
          <refname>${name}</refname>
          <refpurpose>${typeDocbook}</refpurpose>
        </refnamediv>

        <refsect1 role="description">
          <title>Description</title>
          <para>${description}</para>
          <para>Source: ${mkGithubLink pos.file pos.line}</para>
        </refsect1>

        ${paramsDocbook}

        ${returnDocbook}

        ${exampleDocbook}


      </refentry>

    '';



  libSetDocFragments = libgroupname: libset: lib.mapAttrsToList
    (name: value:
      let
        pos = builtins.unsafeGetAttrPos name libset;
      in docbookFromDoc { inherit pos name libgroupname; } value
    )
    (if builtins.hasAttr "docs" libset then libset.docs else {});

  libDocFragments = lib.mapAttrsToList
    (name: value:
      let
        docs = (lib.strings.concatStrings (libSetDocFragments name value));
      in if builtins.stringLength docs == 0
      then ""
      else ''
        <section xml:id="fn-${cleanId name}">
          <title>${name}</title>

          ${docs}
        </section>
      ''
    )
    (attrsOnly lib);
in writeTextDir "lib-funcs.xml"
  ''
    <chapter xmlns="http://docbook.org/ns/docbook"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:id="chap-lib-functions">

      <title>Library Function Reference</title>

      ${lib.concatStringsSep "\n" libDocFragments}
    </chapter>
  ''
