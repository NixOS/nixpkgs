# Avaliação frente às competências da vaga

Escopo: avaliação do artefato local e da especificação anexada. Não avalia anos de
experiência, histórico profissional, liderança ou resultados de clientes. As
“skills” abaixo são as competências da descrição da vaga; nenhum plugin adicional
é necessário para implementar este módulo Rust.

| Competência solicitada | Evidência neste trabalho | Limite / evidência que falta |
|---|---|---|
| Convenções de entidades e resolução | IDs tipados, blocking por ação, contrato de comparações, desempate estável | Normalização de domínio, aliases, entidades incompletas e políticas de identidade |
| Ambiguidades e conflitos explícitos | Conflict determinístico, Novel conservador, registro separado de cold start | Fila de revisão, justificativas por atributo, proveniência das fontes |
| Matching probabilístico | FS com EM, separação treino/inferência, comparação entre backends | Dataset rotulado, precision/recall, calibração e identificação do modelo |
| Qualidade e regressões | Testes de erros, logs, modalidades, caches e isolamento | Avaliação temporal, métricas por domínio e gates de dados reais |
| Governança semântica | Weak permission; ADRs; snapshot imutável por conteúdo; seis bindings de auditoria, parâmetros e versões tipadas no registro/erro | Versionamento do grafo completo, migrações, armazenamento/execução de replay e compatibilidade entre consumidores |
| Graph/semantic store | Tipos mínimos para invariantes | Nenhum Neo4j/Neptune/RDF/OWL/SPARQL implementado ou avaliado |
| Engenharia de dados e escala | Backend DuckDB opcional e cache limitado | Ingestão, Spark/Airflow/dbt, observabilidade, benchmarks e orçamento de pares |
| Retrieval, embeddings e agentes | Interface Rust isolada reutilizável | RAG híbrido, embeddings/refresh, contratos HTTP/MCP e integração com agentes |
| Extração e enriquecimento NLP | Não implementados | Extração de entidades/relações, taxonomias e qualidade de enriquecimento |
| Priors para modelos Bayesianos | Uso local de prior de match | Não demonstra fornecimento de priors comerciais para ROI, marca ou pricing |
| Privacidade e governança de dados | Falhas de log preservam diagnóstico e resultado opaco | Controle de acesso, retenção, PII, linhagem e armazenamento durável |
| Liderança e stakeholders | ADR e revisão técnica tornam decisões revisáveis | Gestão, mentoria, comunicação com clientes e impacto de negócio não inferíveis |
| Uso rigoroso de IA | Especificação confrontada com compilação e execução; erros estatísticos registrados | Evidência de uso contínuo e produtividade requer histórico observável |

O artefato demonstra uma parte delimitada de entity resolution e engenharia de
qualidade. Não sustenta a afirmação de plataforma de ontologia em produção nem,
isoladamente, adequação ao cargo de liderança descrito.

## Próximas evidências para aproximar o projeto da vaga

1. Criar benchmark rotulado de invariantes por ação, com casos incompletos,
   conflitantes e adversariais; medir precisão, recall, calibração e custo de erros.
   Fixar critérios de aprovação com donos do domínio antes de ligar auto-merge.
2. Introduzir revisão explícita de casos ambíguos e provas de subsunção onde
   refinamento tiver efeito normativo; não promover specificity a prova lógica.
3. Integrar grafo versionado, proveniência e log durável transacional; exercitar
   recuperação, replay e migrações de schema/contratos com consumidores existentes.
4. Demonstrar ingestão incremental e limites de blocking com benchmarks por tamanho
   e distribuição de blocos, medindo memória, latência, throughput e concorrência.
5. Expor consultas semânticas/híbridas para um consumidor real, com avaliação de
   retrieval e propagação versionada para agentes e modelos estatísticos.
6. Preparar um caso de ROI, marca ou pricing com resultados verificáveis e decisões
   de arquitetura traduzidas para impactos comerciais; documentar trabalho de equipe.

Nenhuma competência profissional ausente foi presumida, e os corpora sintéticos
servem para testar contratos, não para medir desempenho no domínio comercial.
