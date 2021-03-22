/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   SPDX-FileCopyrightText: 2019 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *   License-Filename: LICENSE
 */

#ifndef FREEBSDJOB_H
#define FREEBSDJOB_H

#include "CppJob.h"
#include "DllMacro.h"
#include "utils/PluginFactory.h"

#include <QObject>
#include <QVariantMap>


class PLUGINDLLEXPORT FreeBSDJob : public Calamares::CppJob
{
    Q_OBJECT

public:
    explicit FreeBSDJob( QObject* parent = nullptr );
    virtual ~FreeBSDJob() override;

    QString prettyName() const override;

    Calamares::JobResult exec() override;

    void setConfigurationMap( const QVariantMap& configurationMap ) override;

private:
    QVariantMap m_configurationMap;
};

CALAMARES_PLUGIN_FACTORY_DECLARATION( FreeBSDJobFactory )

#endif  // FREEBSDJOB_H
