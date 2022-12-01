<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:nixos="tag:nixos.org"
                xmlns="http://docbook.org/ns/docbook"
                extension-element-prefixes="str"
                >

  <xsl:output method='xml' encoding="UTF-8" />

  <xsl:param name="documentType" />
  <xsl:param name="variablelistId" />
  <xsl:param name="optionIdPrefix" />


  <xsl:template match="/expr/list">
    <xsl:choose>
      <xsl:when test="$documentType = 'appendix'">
        <appendix xml:id="appendix-configuration-options">
          <title>Configuration Options</title>
          <xsl:call-template name="variable-list"/>
        </appendix>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="variable-list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="variable-list">
      <variablelist>
      <xsl:attribute name="id" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="$variablelistId"/></xsl:attribute>
        <xsl:for-each select="attrs">
          <xsl:variable name="id" select="
            concat($optionIdPrefix,
              translate(
                attr[@name = 'name']/string/@value,
                '*&lt; >[]:&quot;',
                '________'
            ))" />
          <varlistentry>
            <term xlink:href="#{$id}">
              <xsl:attribute name="xml:id"><xsl:value-of select="$id"/></xsl:attribute>
              <option>
                <xsl:value-of select="attr[@name = 'name']/string/@value" />
              </option>
            </term>

            <listitem>

              <nixos:option-description>
                <para>
                  <xsl:value-of disable-output-escaping="yes"
                                select="attr[@name = 'description']/string/@value" />
                </para>
              </nixos:option-description>

              <xsl:if test="attr[@name = 'type']">
                <para>
                  <emphasis>Type:</emphasis>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="attr[@name = 'type']/string/@value"/>
                  <xsl:if test="attr[@name = 'readOnly']/bool/@value = 'true'">
                    <xsl:text> </xsl:text>
                    <emphasis>(read only)</emphasis>
                  </xsl:if>
                </para>
              </xsl:if>

              <xsl:if test="attr[@name = 'default']">
                <para>
                  <emphasis>Default:</emphasis>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select="attr[@name = 'default']/*" mode="top" />
                </para>
              </xsl:if>

              <xsl:if test="attr[@name = 'example']">
                <para>
                  <emphasis>Example:</emphasis>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select="attr[@name = 'example']/*" mode="top" />
                </para>
              </xsl:if>

              <xsl:if test="attr[@name = 'relatedPackages']">
                <para>
                  <emphasis>Related packages:</emphasis>
                  <xsl:text> </xsl:text>
                  <xsl:value-of disable-output-escaping="yes"
                                select="attr[@name = 'relatedPackages']/string/@value" />
                </para>
              </xsl:if>

              <xsl:if test="count(attr[@name = 'declarations']/list/*) != 0">
                <para>
                  <emphasis>Declared by:</emphasis>
                </para>
                <xsl:apply-templates select="attr[@name = 'declarations']" />
              </xsl:if>

              <xsl:if test="count(attr[@name = 'definitions']/list/*) != 0">
                <para>
                  <emphasis>Defined by:</emphasis>
                </para>
                <xsl:apply-templates select="attr[@name = 'definitions']" />
              </xsl:if>

            </listitem>

          </varlistentry>

        </xsl:for-each>

      </variablelist>
  </xsl:template>


  <xsl:template match="attrs[attr[@name = '_type' and string[@value = 'literalExpression']]]" mode = "top">
    <xsl:choose>
      <xsl:when test="contains(attr[@name = 'text']/string/@value, '&#010;')">
        <programlisting><xsl:value-of select="attr[@name = 'text']/string/@value" /></programlisting>
      </xsl:when>
      <xsl:otherwise>
        <literal><xsl:value-of select="attr[@name = 'text']/string/@value" /></literal>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="attrs[attr[@name = '_type' and string[@value = 'literalDocBook']]]" mode = "top">
    <xsl:value-of disable-output-escaping="yes" select="attr[@name = 'text']/string/@value" />
  </xsl:template>


  <xsl:template match="string[contains(@value, '&#010;')]" mode="top">
    <programlisting>
      <xsl:text>''&#010;</xsl:text>
      <xsl:value-of select='str:replace(str:replace(@value, "&apos;&apos;", "&apos;&apos;&apos;"), "${", "&apos;&apos;${")' />
      <xsl:text>''</xsl:text>
    </programlisting>
  </xsl:template>


  <xsl:template match="*" mode="top">
    <literal><xsl:apply-templates select="." /></literal>
  </xsl:template>


  <xsl:template match="null">
    <xsl:text>null</xsl:text>
  </xsl:template>


  <xsl:template match="string">
    <xsl:choose>
      <xsl:when test="(contains(@value, '&quot;') or contains(@value, '\')) and not(contains(@value, '&#010;'))">
        <xsl:text>''</xsl:text><xsl:value-of select='str:replace(str:replace(@value, "&apos;&apos;", "&apos;&apos;&apos;"), "${", "&apos;&apos;${")' /><xsl:text>''</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"</xsl:text><xsl:value-of select="str:replace(str:replace(str:replace(str:replace(@value, '\', '\\'), '&quot;', '\&quot;'), '&#010;', '\n'), '${', '\${')" /><xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="int">
    <xsl:value-of select="@value" />
  </xsl:template>


  <xsl:template match="bool[@value = 'true']">
    <xsl:text>true</xsl:text>
  </xsl:template>


  <xsl:template match="bool[@value = 'false']">
    <xsl:text>false</xsl:text>
  </xsl:template>


  <xsl:template match="list">
    [
    <xsl:for-each select="*">
      <xsl:apply-templates select="." />
      <xsl:text> </xsl:text>
    </xsl:for-each>
    ]
  </xsl:template>


  <xsl:template match="attrs[attr[@name = '_type' and string[@value = 'literalExpression']]]">
    <xsl:value-of select="attr[@name = 'text']/string/@value" />
  </xsl:template>


  <xsl:template match="attrs">
    {
    <xsl:for-each select="attr">
      <xsl:value-of select="@name" />
      <xsl:text> = </xsl:text>
      <xsl:apply-templates select="*" /><xsl:text>; </xsl:text>
    </xsl:for-each>
    }
  </xsl:template>


  <xsl:template match="attrs[attr[@name = '_type' and string[@value = 'derivation']]]">
    <replaceable>(build of <xsl:value-of select="attr[@name = 'name']/string/@value" />)</replaceable>
  </xsl:template>

  <xsl:template match="attr[@name = 'declarations' or @name = 'definitions']">
    <simplelist>
      <!--
        Example:
          opt.declarations = [
            { source = "nixpkgs"; path = "foo/bar.nix"; url = ...; } # <nixpkgs/foo/bar.nix>
            { path = "/foo/bar.nix"; }                               # links to file:///foo/bar.nix
            { path = "foo/bar.nix"; }                                # no link
          ];
      -->
      <xsl:for-each select="list/attrs[attr[@name = 'path']]">
        <member><filename>
          <xsl:choose>
            <xsl:when test="attr[@name = 'url']">
              <xsl:attribute name="xlink:href"><xsl:value-of select="attr[@name = 'url']/string/@value"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="attr[@name = 'source']"></xsl:when>
            <xsl:when test="starts-with(attr[@name = 'path']/string/@value, '/')">
              <xsl:attribute name="xlink:href">file://<xsl:value-of select="str:encode-uri(attr[@name = 'path']/string/@value, false())" /></xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="attr[@name = 'source']">
              &lt;<xsl:value-of select="attr[@name = 'source']/string/@value"/>/<xsl:value-of select="attr[@name = 'path']/string/@value"/>&gt;
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="attr[@name = 'path']/string/@value"/>
            </xsl:otherwise>
          </xsl:choose>
        </filename></member>
      </xsl:for-each>
    </simplelist>
  </xsl:template>


  <xsl:template match="function">
    <xsl:text>λ</xsl:text>
  </xsl:template>


</xsl:stylesheet>
