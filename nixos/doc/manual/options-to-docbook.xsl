<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns="http://docbook.org/ns/docbook"
                extension-element-prefixes="str"
                >

  <xsl:output method='xml' encoding="UTF-8" />

  <xsl:param name="revision" />


  <xsl:template match="/expr/list">

      <variablelist>

        <xsl:for-each select="attrs">

          <varlistentry>
             <term>
               <option>
                 <xsl:for-each select="attr[@name = 'name']/string">
                   <xsl:value-of select="@value" />
                   <xsl:if test="position() != last()">.</xsl:if>
                 </xsl:for-each>
               </option>
             </term>

             <listitem>

               <para>
                 <xsl:value-of disable-output-escaping="yes"
                               select="attr[@name = 'description']/string/@value" />
               </para>

               <xsl:if test="attr[@name = 'default']">
                 <para>
                   <emphasis>Default:</emphasis>
                   <xsl:text> </xsl:text>
                   <xsl:apply-templates select="attr[@name = 'default']" mode="top" />
                 </para>
               </xsl:if>

               <xsl:if test="attr[@name = 'example']">
                 <para>
                   <emphasis>Example:</emphasis>
                   <xsl:text> </xsl:text>
                   <xsl:choose>
                     <xsl:when test="attr[@name = 'example']/attrs[attr[@name = '_type' and string[@value = 'literalExample']]]">
                       <programlisting><xsl:value-of select="attr[@name = 'example']/attrs/attr[@name = 'text']/string/@value" /></programlisting>
                     </xsl:when>
                     <xsl:otherwise>
                       <xsl:apply-templates select="attr[@name = 'example']" mode="top" />
                     </xsl:otherwise>
                   </xsl:choose>
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


  <xsl:template match="*" mode="top">
    <xsl:choose>
      <xsl:when test="string[contains(@value, '&#010;')]">
<programlisting>
<xsl:text>''
</xsl:text><xsl:value-of select='str:replace(string/@value, "${", "&apos;&apos;${")' /><xsl:text>''</xsl:text></programlisting>
      </xsl:when>
      <xsl:otherwise>
        <literal><xsl:apply-templates /></literal>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="null">
    <xsl:text>null</xsl:text>
  </xsl:template>


  <xsl:template match="string">
    <xsl:choose>
      <xsl:when test="(contains(@value, '&quot;') or contains(@value, '\')) and not(contains(@value, '&#010;'))">
        <xsl:text>''</xsl:text><xsl:value-of select='str:replace(@value, "${", "&apos;&apos;${")' /><xsl:text>''</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"</xsl:text><xsl:value-of select="str:replace(str:replace(str:replace(str:replace(@value, '\', '\\'), '&quot;', '\&quot;'), '&#010;', '\n'), '$', '\$')" /><xsl:text>"</xsl:text>
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


  <xsl:template match="attrs[attr[@name = '_type' and string[@value = 'literalExample']]]">
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


  <xsl:template match="derivation">
    <xsl:choose>
      <xsl:when test="attr[@name = 'url']/string/@value">
        <replaceable>(download of <xsl:value-of select="attr[@name = 'url']/string/@value" />)</replaceable>
      </xsl:when>
      <xsl:otherwise>
        <replaceable>(build of <xsl:value-of select="attr[@name = 'name']/string/@value" />)</replaceable>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="attr[@name = 'declarations' or @name = 'definitions']">
    <simplelist>
      <xsl:for-each select="list/string">
        <member><filename>
          <!-- Hyperlink the filename either to the NixOS Subversion
          repository (if it’s a module and we have a revision number),
          or to the local filesystem. -->
          <xsl:choose>
            <xsl:when test="not(starts-with(@value, '/'))">
              <xsl:choose>
                <xsl:when test="$revision = 'local'">
                  <xsl:attribute name="xlink:href">https://github.com/NixOS/nixpkgs/blob/master/<xsl:value-of select="@value"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="xlink:href">https://github.com/NixOS/nixpkgs/blob/<xsl:value-of select="$revision"/>/<xsl:value-of select="@value"/></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$revision != 'local' and contains(@value, 'nixops') and contains(@value, '/nix/')">
              <xsl:attribute name="xlink:href">https://github.com/NixOS/nixops/blob/<xsl:value-of select="$revision"/>/nix/<xsl:value-of select="substring-after(@value, '/nix/')"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="xlink:href">file://<xsl:value-of select="@value"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <!-- Print the filename and make it user-friendly by replacing the
          /nix/store/<hash> prefix by the default location of nixos
          sources. -->
          <xsl:choose>
            <xsl:when test="not(starts-with(@value, '/'))">
              &lt;nixpkgs/<xsl:value-of select="@value"/>&gt;
            </xsl:when>
            <xsl:when test="contains(@value, 'nixops') and contains(@value, '/nix/')">
              &lt;nixops/<xsl:value-of select="substring-after(@value, '/nix/')"/>&gt;
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@value" />
            </xsl:otherwise>
          </xsl:choose>
        </filename></member>
      </xsl:for-each>
    </simplelist>
  </xsl:template>

</xsl:stylesheet>
