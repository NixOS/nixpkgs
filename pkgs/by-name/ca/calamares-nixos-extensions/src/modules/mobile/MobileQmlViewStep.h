/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#ifndef PARTITION_QMLVIEWSTEP_H
#define PARTITION_QMLVIEWSTEP_H
#include "Config.h"

#include "utils/PluginFactory.h"
#include "viewpages/QmlViewStep.h"

#include <DllMacro.h>

#include <QObject>
#include <QVariantMap>

class PLUGINDLLEXPORT MobileQmlViewStep : public Calamares::QmlViewStep
{
    Q_OBJECT

public:
    explicit MobileQmlViewStep( QObject* parent = nullptr );

    bool isNextEnabled() const override;
    bool isBackEnabled() const override;
    bool isAtBeginning() const override;
    bool isAtEnd() const override;

    Calamares::JobList jobs() const override;

    void setConfigurationMap( const QVariantMap& configurationMap ) override;
    void onLeave() override;
    QObject* getConfig() override;

private:
    Config* m_config;
    QList< Calamares::job_ptr > m_jobs;
};

CALAMARES_PLUGIN_FACTORY_DECLARATION( MobileQmlViewStepFactory )

#endif  // PARTITION_QMLVIEWSTEP_H
