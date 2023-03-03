<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:exsl="http://exslt.org/common"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:nixos="tag:nixos.org"
                extension-element-prefixes="str exsl">
  <xsl:output method='xml' encoding="UTF-8" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="break-up-description">
    <xsl:param name="input" />
    <xsl:param name="buffer" />

    <!-- Every time we have two newlines following each other, we want to
         break it into </para><para>. -->
    <xsl:variable name="parbreak" select="'&#xa;&#xa;'" />

    <!-- Similar to "(head:tail) = input" in Haskell. -->
    <xsl:variable name="head" select="$input[1]" />
    <xsl:variable name="tail" select="$input[position() &gt; 1]" />

    <xsl:choose>
      <xsl:when test="$head/self::text() and contains($head, $parbreak)">
        <!-- If the haystack provided to str:split() directly starts or
             ends with $parbreak, it doesn't generate a <token/> for that,
             so we are doing this here. -->
        <xsl:variable name="splitted-raw">
          <xsl:if test="starts-with($head, $parbreak)"><token /></xsl:if>
          <xsl:for-each select="str:split($head, $parbreak)">
            <token><xsl:value-of select="node()" /></token>
          </xsl:for-each>
          <!-- Something like ends-with($head, $parbreak), but there is
               no ends-with() in XSLT, so we need to use substring(). -->
          <xsl:if test="
            substring($head, string-length($head) -
                             string-length($parbreak) + 1) = $parbreak
          "><token /></xsl:if>
        </xsl:variable>
        <xsl:variable name="splitted"
                      select="exsl:node-set($splitted-raw)/token" />
        <!-- The buffer we had so far didn't contain any text nodes that
             contain a $parbreak, so we can put the buffer along with the
             first token of $splitted into a para element. -->
        <para xmlns="http://docbook.org/ns/docbook">
          <xsl:apply-templates select="exsl:node-set($buffer)" />
          <xsl:apply-templates select="$splitted[1]/node()" />
        </para>
        <!-- We have already emitted the first splitted result, so the
             last result is going to be set as the new $buffer later
             because its contents may not be directly followed up by a
             $parbreak. -->
        <xsl:for-each select="$splitted[position() &gt; 1
                              and position() &lt; last()]">
          <para xmlns="http://docbook.org/ns/docbook">
            <xsl:apply-templates select="node()" />
          </para>
        </xsl:for-each>
        <xsl:call-template name="break-up-description">
          <xsl:with-param name="input" select="$tail" />
          <xsl:with-param name="buffer" select="$splitted[last()]/node()" />
        </xsl:call-template>
      </xsl:when>
      <!-- Either non-text node or one without $parbreak, which we just
           want to buffer and continue recursing. -->
      <xsl:when test="$input">
        <xsl:call-template name="break-up-description">
          <xsl:with-param name="input" select="$tail" />
          <!-- This essentially appends $head to $buffer. -->
          <xsl:with-param name="buffer">
            <xsl:if test="$buffer">
              <xsl:for-each select="exsl:node-set($buffer)">
                <xsl:apply-templates select="." />
              </xsl:for-each>
            </xsl:if>
            <xsl:apply-templates select="$head" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <!-- No more $input, just put the remaining $buffer in a para. -->
      <xsl:otherwise>
        <para xmlns="http://docbook.org/ns/docbook">
          <xsl:apply-templates select="exsl:node-set($buffer)" />
        </para>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="nixos:option-description">
    <xsl:choose>
      <!--
        Only process nodes that are comprised of a single <para/> element,
        because if that's not the case the description already contains
        </para><para> in between and we need no further processing.
      -->
      <xsl:when test="count(db:para) > 1">
        <xsl:apply-templates select="node()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="break-up-description">
          <xsl:with-param name="input"
                          select="exsl:node-set(db:para/node())" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
